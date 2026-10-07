package com.project.controller.owner;

import com.project.dao.AddonDAO;
import com.project.dao.AddonDAOImpl;
import com.project.dao.HomestayDAO;
import com.project.dao.HomestayDAOImpl;
import com.project.model.Addon;
import com.project.model.Homestay;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Controller: Owner — Manage Extra Add-on Services (UC20)
 * URL: /owner/addons
 * Package: com.project.controller.owner
 *
 * GET  — load all addons for owner's homestays from DB
 * POST ?action=create   — create new addon
 * POST ?action=update   — update existing addon
 * POST ?action=delete   — delete addon (blocked if has active bookings)
 * POST ?action=toggle   — toggle is_available on/off
 */
@WebServlet(name = "OwnerAddonController", urlPatterns = {"/owner/addons"})
public class OwnerAddonController extends HttpServlet {

    private AddonDAO    addonDAO;
    private HomestayDAO homestayDAO;

    @Override
    public void init() throws ServletException {
        this.addonDAO    = new AddonDAOImpl();
        this.homestayDAO = new HomestayDAOImpl();
    }

    // ── GET ────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User owner = requireOwner(request, response);
        if (owner == null) return;

        int ownerId = owner.getUserId();

        List<Addon>     addonList   = addonDAO.getAllAddonsByOwnerId(ownerId);
        List<Homestay>  myHomestays = homestayDAO.getHomestaysByOwnerId(ownerId);

        // Group addons by name (case-insensitive) — for-loop, no streams
        Map<String, List<Addon>> grouped = new LinkedHashMap<>();
        for (Addon a : addonList) {
            String key = a.getName().trim().toLowerCase();
            if (!grouped.containsKey(key)) {
                grouped.put(key, new ArrayList<>());
            }
            grouped.get(key).add(a);
        }
        List<List<Addon>> addonGroups = new ArrayList<>(grouped.values());
        request.setAttribute("addonGroups", addonGroups);

        long countActive   = addonList.stream().filter(Addon::isAvailable).count();
        long countInactive = addonList.size() - countActive;

        request.setAttribute("addonList",   addonList);
        request.setAttribute("myHomestays", myHomestays);
        request.setAttribute("countActive",   (int) countActive);
        request.setAttribute("countInactive", (int) countInactive);
        request.setAttribute("countTotal",    addonList.size());

        request.setAttribute("activeTab",      "addons");
        request.setAttribute("pageTitle",      "Chủ nhà - Dịch vụ Bổ sung");
        request.setAttribute("pageBreadcrumb", "Quản lý Tài sản");

        request.getRequestDispatcher("/WEB-INF/views/owner/addons.jsp").forward(request, response);
    }

    // ── POST ───────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User owner = requireOwner(request, response);
        if (owner == null) return;

        int ownerId = owner.getUserId();
        String action = trim(request.getParameter("action"));

        switch (action) {
            case "create": handleCreate(request, response, ownerId); break;
            case "update": handleUpdate(request, response, ownerId); break;
            case "delete": handleDelete(request, response, ownerId); break;
            case "toggle": handleToggle(request, response, ownerId); break;
            case "updateGroup": handleUpdateGroup(request, response, ownerId); break;
            default:
                response.sendRedirect(request.getContextPath() + "/owner/addons");
        }
    }

    // ── Action handlers ────────────────────────────────────────────────────

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();

        String name        = trim(request.getParameter("addonName"));
        String description = trim(request.getParameter("addonDescription"));
        String priceStr    = trim(request.getParameter("addonPrice"));
        String unit        = trim(request.getParameter("addonUnit"));
        String[] hsIds     = request.getParameterValues("homestayId");   // multi-select array

        if (name.isEmpty() || priceStr.isEmpty() || unit.isEmpty() || hsIds == null || hsIds.length == 0) {
            session.setAttribute("flash_error", "Vui lòng điền đầy đủ tên, giá, đơn vị và chọn ít nhất một cơ sở.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        BigDecimal price;
        try {
            price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) < 0) throw new NumberFormatException("negative price");
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Giá không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // Validate & collect eligible homestay IDs
        List<Homestay> validHomestays = new ArrayList<>();
        for (String hsIdStr : hsIds) {
            int hsId = parseId(hsIdStr);
            Homestay hs = homestayDAO.getHomestayById(hsId).orElse(null);
            if (hs != null && hs.getOwnerId() == ownerId) {
                validHomestays.add(hs);
            }
        }

        if (validHomestays.isEmpty()) {
            session.setAttribute("flash_error", "Không có cơ sở hợp lệ nào được chọn.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // Create one addon per selected homestay
        int created = 0;
        for (Homestay hs : validHomestays) {
            Addon a = new Addon();
            a.setHomestayId(hs.getHomestayId());
            a.setName(name);
            a.setDescription(description.isEmpty() ? null : description);
            a.setPrice(price);
            a.setUnit(unit);
            a.setAvailable(true);
            if (addonDAO.insertAddon(a) > 0) created++;
        }

        if (created > 0) {
            String msg = created == 1
                ? "Đã thêm dịch vụ <strong>" + escHtml(name) + "</strong> vào " + escHtml(validHomestays.get(0).getName()) + "."
                : "Đã thêm dịch vụ <strong>" + escHtml(name) + "</strong> cho " + created + " cơ sở.";
            session.setAttribute("flash_success", msg);
        } else {
            session.setAttribute("flash_error", "Thêm dịch vụ thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/owner/addons");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        int addonId = parseId(request.getParameter("addonId"));
        if (addonId <= 0 || !addonDAO.isAddonOwnedBy(addonId, ownerId)) {
            session.setAttribute("flash_error", "Dịch vụ không tồn tại hoặc không thuộc quyền của bạn.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        String name        = trim(request.getParameter("addonName"));
        String description = trim(request.getParameter("addonDescription"));
        String priceStr    = trim(request.getParameter("addonPrice"));
        String unit        = trim(request.getParameter("addonUnit"));
        String[] allHsIds  = request.getParameterValues("homestayId");  // includes current + any extras

        if (name.isEmpty() || priceStr.isEmpty() || unit.isEmpty()) {
            session.setAttribute("flash_error", "Vui lòng điền đầy đủ tên, giá và đơn vị.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        BigDecimal price;
        try {
            price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) < 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Giá không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // Update the current addon
        Addon current = addonDAO.getAddonById(addonId).orElse(new Addon());
        int currentHomestayId = current.getHomestayId();
        current.setAddonId(addonId);
        current.setName(name);
        current.setDescription(description.isEmpty() ? null : description);
        current.setPrice(price);
        current.setUnit(unit);
        addonDAO.updateAddon(current);

        // For any additional (newly ticked) homestays, create a copy
        int copied = 0;
        if (allHsIds != null) {
            for (String hsIdStr : allHsIds) {
                int hsId = parseId(hsIdStr);
                if (hsId == currentHomestayId) continue;  // already updated above
                Homestay hs = homestayDAO.getHomestayById(hsId).orElse(null);
                if (hs != null && hs.getOwnerId() == ownerId) {
                    Addon copy = new Addon();
                    copy.setHomestayId(hsId);
                    copy.setName(name);
                    copy.setDescription(description.isEmpty() ? null : description);
                    copy.setPrice(price);
                    copy.setUnit(unit);
                    copy.setAvailable(true);
                    if (addonDAO.insertAddon(copy) > 0) copied++;
                }
            }
        }

        String msg = "Đã cập nhật dịch vụ <strong>" + escHtml(name) + "</strong>.";
        if (copied > 0) msg += " Đã nhân bản sang " + copied + " cơ sở khác.";
        session.setAttribute("flash_success", msg);
        response.sendRedirect(request.getContextPath() + "/owner/addons");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        int addonId = parseId(request.getParameter("addonId"));
        if (addonId <= 0 || !addonDAO.isAddonOwnedBy(addonId, ownerId)) {
            session.setAttribute("flash_error", "Dịch vụ không tồn tại hoặc không thuộc quyền của bạn.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        if (addonDAO.hasActiveBookings(addonId)) {
            session.setAttribute("flash_error",
                "Không thể xóa dịch vụ này vì đang có đơn đặt phòng đang hoạt động sử dụng nó.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        Addon a = addonDAO.getAddonById(addonId).orElse(null);
        if (addonDAO.deleteAddon(addonId)) {
            String name = a != null ? a.getName() : "dịch vụ";
            session.setAttribute("flash_success", "Đã xóa dịch vụ <strong>" + escHtml(name) + "</strong>.");
        } else {
            session.setAttribute("flash_error", "Xóa thất bại. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/owner/addons");
    }

    private void handleToggle(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();
        int addonId = parseId(request.getParameter("addonId"));
        if (addonId <= 0 || !addonDAO.isAddonOwnedBy(addonId, ownerId)) {
            session.setAttribute("flash_error", "Dịch vụ không tồn tại hoặc không thuộc quyền của bạn.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        Addon a = addonDAO.getAddonById(addonId).orElse(null);
        if (a == null) {
            session.setAttribute("flash_error", "Không tìm thấy dịch vụ.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        boolean newState = !a.isAvailable();
        addonDAO.toggleAvailable(addonId, newState);

        String state = newState ? "mở bán" : "tạm ngừng";
        session.setAttribute("flash_success",
            "Đã " + state + " dịch vụ <strong>" + escHtml(a.getName()) + "</strong>.");
        response.sendRedirect(request.getContextPath() + "/owner/addons");
    }

    private void handleUpdateGroup(HttpServletRequest request, HttpServletResponse response, int ownerId)
            throws IOException {

        HttpSession session = request.getSession();

        String addonIdsParam = trim(request.getParameter("addonIds"));
        String name          = trim(request.getParameter("addonName"));
        String description   = trim(request.getParameter("addonDescription"));
        String priceStr      = trim(request.getParameter("addonPrice"));
        String unit          = trim(request.getParameter("addonUnit"));
        if (unit.isEmpty()) unit = "per_booking"; // fallback: browser may send empty when select had no valid selection
        String[] hsIdParams  = request.getParameterValues("homestayId");

        // (b) Validate required fields
        if (addonIdsParam.isEmpty() || name.isEmpty() || priceStr.isEmpty()) {
            session.setAttribute("flash_error", "Vui lòng điền đầy đủ thông tin dịch vụ.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // (c) Parse price
        BigDecimal price;
        try {
            price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) < 0) throw new NumberFormatException("negative price");
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Giá không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // (d) Build existingMap: homestayId -> Addon from comma-separated addonIds
        Map<Integer, Addon> existingMap = new LinkedHashMap<>();
        String[] addonIdParts = addonIdsParam.split(",");
        for (String part : addonIdParts) {
            int addonId = parseId(part.trim());
            if (addonId <= 0) continue;
            if (!addonDAO.isAddonOwnedBy(addonId, ownerId)) continue;
            Addon a = addonDAO.getAddonById(addonId).orElse(null);
            if (a == null) continue;
            existingMap.put(a.getHomestayId(), a);
        }

        // (e) Guard: existingMap must not be empty
        if (existingMap.isEmpty()) {
            session.setAttribute("flash_error", "Không tìm thấy dịch vụ hợp lệ để cập nhật.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        // (f) Build selectedHsIds from POST params, validated against owner
        Set<Integer> selectedHsIds = new LinkedHashSet<>();
        if (hsIdParams != null) {
            for (String hsIdStr : hsIdParams) {
                int hsId = parseId(hsIdStr);
                if (hsId <= 0) continue;
                Homestay hs = homestayDAO.getHomestayById(hsId).orElse(null);
                if (hs != null && hs.getOwnerId() == ownerId) {
                    selectedHsIds.add(hsId);
                }
            }
        }

        // (g) Guard: at least one valid homestay selected
        if (selectedHsIds.isEmpty()) {
            session.setAttribute("flash_error", "Không có cơ sở hợp lệ nào được chọn.");
            response.sendRedirect(request.getContextPath() + "/owner/addons");
            return;
        }

        int updated = 0;
        int added   = 0;

        // (h) Update existing entries or create new copies for selected homestays
        for (int hsId : selectedHsIds) {
            if (existingMap.containsKey(hsId)) {
                Addon a = existingMap.get(hsId);
                a.setName(name);
                a.setDescription(description.isEmpty() ? null : description);
                a.setPrice(price);
                a.setUnit(unit);
                addonDAO.updateAddon(a);
                updated++;
            } else {
                Addon copy = new Addon();
                copy.setHomestayId(hsId);
                copy.setName(name);
                copy.setDescription(description.isEmpty() ? null : description);
                copy.setPrice(price);
                copy.setUnit(unit);
                copy.setAvailable(true);
                if (addonDAO.insertAddon(copy) > 0) added++;
            }
        }

        // (i) Delete (with hasActiveBookings guard) for deselected homestays
        int removed = 0;
        int skipped = 0;
        for (Map.Entry<Integer, Addon> entry : existingMap.entrySet()) {
            int hsId = entry.getKey();
            if (selectedHsIds.contains(hsId)) continue;
            int addonId = entry.getValue().getAddonId();
            if (addonDAO.hasActiveBookings(addonId)) {
                skipped++;
            } else {
                if (addonDAO.deleteAddon(addonId)) removed++;
            }
        }

        // (j) Build flash message
        String msg = "Đã cập nhật dịch vụ <strong>" + escHtml(name) + "</strong>.";
        if (added   > 0) msg += " Đã thêm vào " + added + " cơ sở mới.";
        if (removed > 0) msg += " Đã xóa khỏi " + removed + " cơ sở.";
        if (skipped > 0) msg += " Bỏ qua " + skipped + " cơ sở (đang có đặt phòng hoạt động).";
        session.setAttribute("flash_success", msg);
        response.sendRedirect(request.getContextPath() + "/owner/addons");
    }

    // ── Utilities ──────────────────────────────────────────────────────────

    private User requireOwner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return null; }
        if (user.getRole() != User.Role.OWNER) { response.sendRedirect(request.getContextPath() + "/home"); return null; }
        return user;
    }

    private static int parseId(String s) {
        try { return s != null ? Integer.parseInt(s.trim()) : -1; }
        catch (NumberFormatException e) { return -1; }
    }

    private static String trim(String s) { return s != null ? s.trim() : ""; }

    private static String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
    }
}
