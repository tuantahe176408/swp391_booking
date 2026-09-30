package com.project.controller.owner;

import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Homestay;
import com.project.model.HomestayImage;
import com.project.model.User;
import com.project.util.CloudinaryUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.sql.Time;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller: Edit/Create Homestay (UC17) + Image Management via Cloudinary
 *
 * GET  /owner/homestays/new          — empty create form
 * GET  /owner/homestays/edit?id=X    — load edit form with current images
 * POST /owner/homestays/edit         — save text fields + upload new images
 * POST /owner/homestays/toggle       — toggle ACTIVE ↔ INACTIVE
 * POST /owner/homestays/delete-image — delete one image (Cloudinary + DB)
 * POST /owner/homestays/set-primary  — set an image as the primary photo
 *
 * Package: com.project.controller.owner
 */
@WebServlet(
    name = "OwnerHomestayEditController",
    urlPatterns = {
        "/owner/homestays/edit",
        "/owner/homestays/toggle",
        "/owner/homestays/new",
        "/owner/homestays/delete-image",
        "/owner/homestays/set-primary"
    }
)
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB — buffer before writing to disk
    maxFileSize       = 10 * 1024 * 1024,  // 10 MB per image
    maxRequestSize    = 60 * 1024 * 1024   // 60 MB total (up to 6 images × 10 MB)
)
public class OwnerHomestayEditController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OwnerHomestayEditController.class.getName());
    private final HomestayDAO homestayDAO = new HomestayDAOImpl();

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = requireOwner(request, response);
        if (currentUser == null) return;

        String uri = request.getRequestURI();

        if (uri.endsWith("/new")) {
            request.setAttribute("homestay",       new Homestay());
            request.setAttribute("isNew",          true);
            request.setAttribute("images",         List.of());
            request.setAttribute("activeTab",      "homestays");
            request.setAttribute("pageTitle",      "Đăng ký Homestay mới");
            request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
            request.getRequestDispatcher("/WEB-INF/views/owner/homestay-edit.jsp")
                   .forward(request, response);
            return;
        }

        // Edit existing
        int hsId = parseId(request.getParameter("id"), 0);
        if (hsId == 0) { response.sendRedirect(request.getContextPath() + "/owner/homestays"); return; }

        Optional<Homestay> opt = homestayDAO.getHomestayById(hsId);
        if (opt.isEmpty() || opt.get().getOwnerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/owner/homestays");
            return;
        }

        List<HomestayImage> images = homestayDAO.getHomestayImages(hsId);

        request.setAttribute("homestay",       opt.get());
        request.setAttribute("isNew",          false);
        request.setAttribute("images",         images);
        request.setAttribute("activeTab",      "homestays");
        request.setAttribute("pageTitle",      "Chỉnh sửa Homestay");
        request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");
        request.getRequestDispatcher("/WEB-INF/views/owner/homestay-edit.jsp")
               .forward(request, response);
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User currentUser = requireOwner(request, response);
        if (currentUser == null) return;

        String uri = request.getRequestURI();

        // ── Toggle ACTIVE ↔ INACTIVE ─────────────────────────────────────────
        if (uri.endsWith("/toggle")) {
            handleToggle(request, response, currentUser);
            return;
        }

        // ── Delete one image ─────────────────────────────────────────────────
        if (uri.endsWith("/delete-image")) {
            handleDeleteImage(request, response, currentUser);
            return;
        }

        // ── Set primary image ────────────────────────────────────────────────
        if (uri.endsWith("/set-primary")) {
            handleSetPrimary(request, response, currentUser);
            return;
        }

        // ── Save: NEW or EDIT ────────────────────────────────────────────────
        boolean isNew = "true".equals(request.getParameter("isNew"));

        if (isNew) {
            handleNewHomestay(request, response, currentUser);
        } else {
            handleEditHomestay(request, response, currentUser);
        }
    }

    // =========================================================================
    // PRIVATE HANDLERS
    // =========================================================================

    /** POST /toggle — change ACTIVE ↔ INACTIVE */
    private void handleToggle(HttpServletRequest req, HttpServletResponse res, User owner)
            throws IOException {
        int hsId  = parseId(req.getParameter("homestayId"), 0);
        String act = req.getParameter("action");
        if (hsId > 0 && act != null) {
            Homestay.Status newStatus = "activate".equals(act)
                    ? Homestay.Status.ACTIVE
                    : Homestay.Status.INACTIVE;
            homestayDAO.updateHomestayStatus(hsId, owner.getUserId(), newStatus);
        }
        res.sendRedirect(req.getContextPath() + "/owner/homestays");
    }

    /** POST /delete-image — delete one image from Cloudinary + DB */
    private void handleDeleteImage(HttpServletRequest req, HttpServletResponse res, User owner)
            throws IOException {
        int imageId   = parseId(req.getParameter("imageId"),   0);
        int homestayId = parseId(req.getParameter("homestayId"), 0);

        if (imageId > 0 && homestayId > 0) {
            // Fetch URL first so we can delete from Cloudinary
            Optional<HomestayImage> imgOpt = homestayDAO.getHomestayImageById(imageId);
            imgOpt.ifPresent(img -> {
                CloudinaryUtil.deleteImage(img.getImageUrl());
            });
            boolean deleted = homestayDAO.deleteHomestayImage(imageId, homestayId, owner.getUserId());
            if (deleted) {
                req.getSession().setAttribute("flash_success", "Đã xóa ảnh thành công.");
            } else {
                req.getSession().setAttribute("flash_error", "Xóa ảnh thất bại. Vui lòng thử lại.");
            }
        }
        res.sendRedirect(req.getContextPath() + "/owner/homestays/edit?id=" + homestayId);
    }

    /** POST /set-primary — mark one image as the primary photo */
    private void handleSetPrimary(HttpServletRequest req, HttpServletResponse res, User owner)
            throws IOException {
        int imageId    = parseId(req.getParameter("imageId"),   0);
        int homestayId = parseId(req.getParameter("homestayId"), 0);

        if (imageId > 0 && homestayId > 0) {
            boolean ok = homestayDAO.setPrimaryHomestayImage(imageId, homestayId, owner.getUserId());
            if (ok) {
                req.getSession().setAttribute("flash_success", "Đã đặt ảnh đại diện thành công.");
            } else {
                req.getSession().setAttribute("flash_error", "Không thể đặt ảnh đại diện. Vui lòng thử lại.");
            }
        }
        res.sendRedirect(req.getContextPath() + "/owner/homestays/edit?id=" + homestayId);
    }

    /** POST /edit (isNew=true) — insert new homestay then upload images */
    private void handleNewHomestay(HttpServletRequest req, HttpServletResponse res, User owner)
            throws ServletException, IOException {

        Homestay hs = new Homestay();
        hs.setOwnerId(owner.getUserId());
        fillHomestayFromRequest(req, hs);

        int newId = homestayDAO.insertHomestay(hs);
        if (newId <= 0) {
            req.getSession().setAttribute("flash_error", "Đăng ký homestay thất bại. Vui lòng thử lại.");
            res.sendRedirect(req.getContextPath() + "/owner/homestays/new");
            return;
        }

        // Upload any attached images
        int uploaded = uploadAndSaveImages(req, newId, owner.getUserId());

        String msg = "Đăng ký homestay \"" + hs.getName() + "\" thành công! Đang chờ Admin xét duyệt.";
        if (uploaded > 0) msg += " Đã tải lên " + uploaded + " ảnh.";
        req.getSession().setAttribute("flash_success", msg);
        res.sendRedirect(req.getContextPath() + "/owner/homestays/edit?id=" + newId);
    }

    /** POST /edit (isNew=false) — update existing homestay info + upload any new images */
    private void handleEditHomestay(HttpServletRequest req, HttpServletResponse res, User owner)
            throws ServletException, IOException {

        int hsId = parseId(req.getParameter("homestayId"), 0);
        if (hsId == 0) { res.sendRedirect(req.getContextPath() + "/owner/homestays"); return; }

        Optional<Homestay> opt = homestayDAO.getHomestayById(hsId);
        if (opt.isEmpty() || opt.get().getOwnerId() != owner.getUserId()) {
            res.sendRedirect(req.getContextPath() + "/owner/homestays");
            return;
        }

        Homestay hs = opt.get();
        fillHomestayFromRequest(req, hs);

        boolean ok = homestayDAO.updateHomestay(hs);

        // Upload any newly attached images (existing images are preserved)
        int uploaded = uploadAndSaveImages(req, hsId, owner.getUserId());

        if (ok || uploaded > 0) {
            String msg = "Cập nhật homestay thành công!";
            if (uploaded > 0)    msg += " Đã tải lên " + uploaded + " ảnh mới.";
            if (opt.get().getStatus() == Homestay.Status.REJECTED) {
                msg += " Cơ sở đã được gửi lại để Admin xét duyệt.";
            }
            req.getSession().setAttribute("flash_success", msg);
        } else {
            req.getSession().setAttribute("flash_error", "Cập nhật thất bại. Vui lòng thử lại.");
        }
        res.sendRedirect(req.getContextPath() + "/owner/homestays/edit?id=" + hsId);
    }

    // =========================================================================
    // HELPERS
    // =========================================================================

    /**
     * Process all file parts named "images" from the multipart request,
     * upload each to Cloudinary, and insert into homestay_images.
     * First image automatically becomes primary if no primary exists yet.
     *
     * @return count of successfully uploaded images
     */
    private int uploadAndSaveImages(HttpServletRequest req, int homestayId, int ownerId)
            throws IOException, ServletException {

        Collection<Part> parts = req.getParts();
        List<HomestayImage> existingImages = homestayDAO.getHomestayImages(homestayId);
        boolean hasPrimary = existingImages.stream().anyMatch(HomestayImage::isPrimary);
        int displayOrder   = existingImages.size(); // append after existing
        int uploaded       = 0;

        for (Part part : parts) {
            if (!"images".equals(part.getName())) continue;
            if (part.getSize() == 0)              continue; // no file selected

            String filename = getSubmittedFilename(part);
            if (!isImage(filename)) {
                LOGGER.warning("[OwnerHomestayEdit] Skipping non-image file: " + filename);
                continue;
            }

            String imageUrl = CloudinaryUtil.uploadImage(
                    part.getInputStream(), filename,
                    "homestays/" + ownerId
            );

            if (imageUrl != null) {
                boolean setPrimary = !hasPrimary;  // first uploaded image becomes primary
                int id = homestayDAO.insertHomestayImage(homestayId, imageUrl, setPrimary, displayOrder);
                if (id > 0) {
                    if (setPrimary) hasPrimary = true;
                    displayOrder++;
                    uploaded++;
                }
            } else {
                LOGGER.warning("[OwnerHomestayEdit] Cloudinary upload failed for: " + filename);
            }
        }
        return uploaded;
    }

    /** Map request text params → Homestay fields (shared between create & edit). */
    private void fillHomestayFromRequest(HttpServletRequest req, Homestay hs) {
        hs.setName(safe(req.getParameter("name")));
        hs.setDescription(safe(req.getParameter("description")));
        hs.setAddress(safe(req.getParameter("address")));
        hs.setCity(safe(req.getParameter("city")));
        hs.setDistrict(safe(req.getParameter("district")));
        String ci = req.getParameter("checkinTime");
        String co = req.getParameter("checkoutTime");
        try { if (ci != null && !ci.isEmpty()) hs.setCheckinTime(Time.valueOf(ci + ":00")); }
        catch (Exception ignored) {}
        try { if (co != null && !co.isEmpty()) hs.setCheckoutTime(Time.valueOf(co + ":00")); }
        catch (Exception ignored) {}
    }

    /** Require authenticated OWNER — redirect to /login otherwise. */
    private User requireOwner(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (u == null) { res.sendRedirect(req.getContextPath() + "/login"); return null; }
        return u;
    }

    /** Extract submitted filename from a multipart Part safely. */
    private static String getSubmittedFilename(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return "upload.jpg";
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.startsWith("filename=") || token.startsWith("filename*=")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // Strip path prefix (IE sends full path)
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return (slash >= 0) ? name.substring(slash + 1) : name;
            }
        }
        return "upload.jpg";
    }

    private static boolean isImage(String filename) {
        if (filename == null) return false;
        String lc = filename.toLowerCase(java.util.Locale.ROOT);
        return lc.endsWith(".jpg") || lc.endsWith(".jpeg")
            || lc.endsWith(".png") || lc.endsWith(".gif")
            || lc.endsWith(".webp") || lc.endsWith(".bmp");
    }

    private static int parseId(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return def; }
    }

    private static String safe(String s) {
        return (s == null) ? "" : s.trim();
    }
}
