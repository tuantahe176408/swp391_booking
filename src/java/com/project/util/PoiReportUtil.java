package com.project.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;

import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility: Generate .xlsx analytics reports for admin (UC25).
 * Package: com.project.util
 *
 * Usage:
 *   PoiReportUtil.writeAnalyticsReport(outputStream, params...)
 *
 * Sheets produced:
 *   1. Tổng quan    — KPI summary (GMV, commission, bookings, platform stats)
 *   2. Doanh thu    — Monthly revenue + booking count time-series
 *   3. Top Homestay — Top homestays ranked by revenue
 *   4. Thanh toán   — Payment method breakdown
 */
public class PoiReportUtil {

    private static final Logger LOGGER = Logger.getLogger(PoiReportUtil.class.getName());

    // ── Brand colour (dark red matching the admin theme) ──────────────────
    private static final byte[] COLOR_PRIMARY   = {(byte)0xC0, (byte)0x10, (byte)0x1A}; // #C0101A
    private static final byte[] COLOR_HEADER_BG = {(byte)0xEF, (byte)0x44, (byte)0x44}; // #ef4444
    private static final byte[] COLOR_ROW_ALT   = {(byte)0xFD, (byte)0xF2, (byte)0xF2}; // light pink
    private static final byte[] COLOR_TITLE_FG  = {(byte)0xFF, (byte)0xFF, (byte)0xFF}; // white

    private PoiReportUtil() {} // static utility

    // ─────────────────────────────────────────────────────────────────────────
    // Public API
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Write the analytics .xlsx workbook to the given OutputStream.
     *
     * @param out              response output stream
     * @param periodLabel      e.g. "Tất cả thời gian"
     * @param totalGmv         total gross merchandise value (VNĐ)
     * @param commissionRev    estimated commission revenue (VNĐ)
     * @param commissionRate   commission rate (%)
     * @param successBookings  count of successful bookings
     * @param cancelledBookings count of cancelled bookings
     * @param activeHomestays  count of active homestays
     * @param totalOwners      count of owners
     * @param totalCustomers   count of customers
     * @param chartRows        time-series: Object[3]{ String label, Long gmv, Integer count }
     * @param topHsRows        top homestays: Object[3]{ String name, Long revenue, Integer count }
     * @param paymentRows      payment breakdown: Object[2]{ String method, Integer count }
     */
    public static void writeAnalyticsReport(
            OutputStream out,
            String periodLabel,
            long   totalGmv,
            long   commissionRev,
            double commissionRate,
            int    successBookings,
            int    cancelledBookings,
            int    activeHomestays,
            int    totalOwners,
            int    totalCustomers,
            List<Object[]> chartRows,
            List<Object[]> topHsRows,
            List<Object[]> paymentRows
    ) {
        try (XSSFWorkbook wb = new XSSFWorkbook()) {

            // Shared styles
            Styles s = new Styles(wb);

            writeSheetOverview(wb, s, periodLabel,
                    totalGmv, commissionRev, commissionRate,
                    successBookings, cancelledBookings,
                    activeHomestays, totalOwners, totalCustomers);

            writeSheetRevenue(wb, s, periodLabel, chartRows);
            writeSheetTopHomestay(wb, s, periodLabel, topHsRows);
            writeSheetPayment(wb, s, paymentRows);

            wb.write(out);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "PoiReportUtil: failed to write xlsx report", e);
            throw new RuntimeException("Excel export failed: " + e.getMessage(), e);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Sheet 1: Tổng quan
    // ─────────────────────────────────────────────────────────────────────────

    private static void writeSheetOverview(XSSFWorkbook wb, Styles s,
            String periodLabel, long gmv, long commission, double rate,
            int success, int cancelled, int activeHs, int owners, int customers) {

        XSSFSheet sheet = wb.createSheet("Tổng quan");
        sheet.setColumnWidth(0, 36 * 256);
        sheet.setColumnWidth(1, 28 * 256);

        int r = 0;

        // Title
        r = writeTitleRow(sheet, s, r, "BÁO CÁO TÀI CHÍNH TOÀN SÀN", 2);
        writeSubtitleRow(sheet, s, r++, "Kỳ: " + periodLabel + "   |   Xuất ngày: " +
                LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")), 2);
        r++; // blank

        // KPI Section
        writeKpiRow(sheet, s, r++, "DOANH THU & HOA HỒNG", null, true);
        writeKpiRow(sheet, s, r++, "Tổng GMV toàn sàn",       fmtVnd(gmv), false);
        writeKpiRow(sheet, s, r++, "Hoa hồng sàn (" + rate + "%)", fmtVnd(commission), false);
        r++; // blank

        writeKpiRow(sheet, s, r++, "ĐẶT PHÒNG", null, true);
        writeKpiRow(sheet, s, r++, "Đơn thành công",  String.valueOf(success),   false);
        writeKpiRow(sheet, s, r++, "Đơn đã hủy",      String.valueOf(cancelled), false);
        double total = success + cancelled;
        String cancelRateFmt = total > 0
                ? String.format("%.1f%%", cancelled / total * 100) : "0%";
        writeKpiRow(sheet, s, r++, "Tỷ lệ hủy",       cancelRateFmt,            false);
        r++;

        writeKpiRow(sheet, s, r++, "TỔNG QUAN NỀN TẢNG", null, true);
        writeKpiRow(sheet, s, r++, "Homestay hoạt động", String.valueOf(activeHs),  false);
        writeKpiRow(sheet, s, r++, "Chủ nhà",             String.valueOf(owners),    false);
        writeKpiRow(sheet, s, r++, "Khách hàng",          String.valueOf(customers), false);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Sheet 2: Doanh thu theo kỳ
    // ─────────────────────────────────────────────────────────────────────────

    private static void writeSheetRevenue(XSSFWorkbook wb, Styles s,
            String periodLabel, List<Object[]> rows) {

        XSSFSheet sheet = wb.createSheet("Doanh thu");
        sheet.setColumnWidth(0, 18 * 256);
        sheet.setColumnWidth(1, 24 * 256);
        sheet.setColumnWidth(2, 14 * 256);

        int r = 0;
        r = writeTitleRow(sheet, s, r, "DOANH THU & SỐ ĐƠN THEO KỲ", 3);
        writeSubtitleRow(sheet, s, r++, "Kỳ: " + periodLabel, 3);
        r++;

        // Header row
        XSSFRow header = sheet.createRow(r++);
        createHeaderCell(header, s, 0, "Kỳ");
        createHeaderCell(header, s, 1, "Doanh thu (₫)");
        createHeaderCell(header, s, 2, "Số đơn");

        // Data rows
        long grandTotal = 0;
        int  grandCount = 0;
        for (int i = 0; i < rows.size(); i++) {
            Object[] row = rows.get(i);
            long  gmv = (Long)    row[1];
            int   cnt = (Integer) row[2];
            grandTotal += gmv;
            grandCount += cnt;

            XSSFRow xr = sheet.createRow(r++);
            xr.createCell(0).setCellValue((String) row[0]);
            xr.getCell(0).setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);

            XSSFCell cGmv = xr.createCell(1);
            cGmv.setCellValue(gmv);
            cGmv.setCellStyle(i % 2 == 0 ? s.moneyEven : s.moneyOdd);

            XSSFCell cCnt = xr.createCell(2);
            cCnt.setCellValue(cnt);
            cCnt.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);
        }

        // Total row
        XSSFRow totRow = sheet.createRow(r);
        XSSFCell tLabel = totRow.createCell(0);
        tLabel.setCellValue("TỔNG CỘNG");
        tLabel.setCellStyle(s.totalLabel);

        XSSFCell tGmv = totRow.createCell(1);
        tGmv.setCellValue(grandTotal);
        tGmv.setCellStyle(s.totalMoney);

        XSSFCell tCnt = totRow.createCell(2);
        tCnt.setCellValue(grandCount);
        tCnt.setCellStyle(s.totalLabel);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Sheet 3: Top Homestay
    // ─────────────────────────────────────────────────────────────────────────

    private static void writeSheetTopHomestay(XSSFWorkbook wb, Styles s,
            String periodLabel, List<Object[]> rows) {

        XSSFSheet sheet = wb.createSheet("Top Homestay");
        sheet.setColumnWidth(0, 6  * 256);
        sheet.setColumnWidth(1, 38 * 256);
        sheet.setColumnWidth(2, 24 * 256);
        sheet.setColumnWidth(3, 14 * 256);

        int r = 0;
        r = writeTitleRow(sheet, s, r, "TOP HOMESTAY THEO DOANH THU", 4);
        writeSubtitleRow(sheet, s, r++, "Kỳ: " + periodLabel, 4);
        r++;

        XSSFRow header = sheet.createRow(r++);
        createHeaderCell(header, s, 0, "Hạng");
        createHeaderCell(header, s, 1, "Tên Homestay");
        createHeaderCell(header, s, 2, "Doanh thu (₫)");
        createHeaderCell(header, s, 3, "Số đơn");

        for (int i = 0; i < rows.size(); i++) {
            Object[] row = rows.get(i);
            XSSFRow xr = sheet.createRow(r++);

            XSSFCell cRank = xr.createCell(0);
            cRank.setCellValue(i + 1);
            cRank.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);

            XSSFCell cName = xr.createCell(1);
            cName.setCellValue((String) row[0]);
            cName.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);

            XSSFCell cRev = xr.createCell(2);
            cRev.setCellValue((Long) row[1]);
            cRev.setCellStyle(i % 2 == 0 ? s.moneyEven : s.moneyOdd);

            XSSFCell cCnt = xr.createCell(3);
            cCnt.setCellValue((Integer) row[2]);
            cCnt.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Sheet 4: Thanh toán
    // ─────────────────────────────────────────────────────────────────────────

    private static void writeSheetPayment(XSSFWorkbook wb, Styles s,
            List<Object[]> rows) {

        XSSFSheet sheet = wb.createSheet("Thanh toán");
        sheet.setColumnWidth(0, 22 * 256);
        sheet.setColumnWidth(1, 16 * 256);
        sheet.setColumnWidth(2, 16 * 256);

        int r = 0;
        r = writeTitleRow(sheet, s, r, "PHÂN BỔ PHƯƠNG THỨC THANH TOÁN", 3);
        writeSubtitleRow(sheet, s, r++, "Chỉ tính giao dịch thành công", 3);
        r++;

        XSSFRow header = sheet.createRow(r++);
        createHeaderCell(header, s, 0, "Phương thức");
        createHeaderCell(header, s, 1, "Số giao dịch");
        createHeaderCell(header, s, 2, "Tỷ lệ (%)");

        int total = rows.stream().mapToInt(row -> (Integer) row[1]).sum();

        for (int i = 0; i < rows.size(); i++) {
            Object[] row = rows.get(i);
            int cnt = (Integer) row[1];
            double pct = total > 0 ? cnt * 100.0 / total : 0;

            XSSFRow xr = sheet.createRow(r++);
            XSSFCell cMethod = xr.createCell(0);
            cMethod.setCellValue((String) row[0]);
            cMethod.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);

            XSSFCell cCnt = xr.createCell(1);
            cCnt.setCellValue(cnt);
            cCnt.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);

            XSSFCell cPct = xr.createCell(2);
            cPct.setCellValue(String.format("%.1f%%", pct));
            cPct.setCellStyle(i % 2 == 0 ? s.dataEven : s.dataOdd);
        }

        // Total row
        XSSFRow totRow = sheet.createRow(r);
        XSSFCell tLabel = totRow.createCell(0);
        tLabel.setCellValue("TỔNG CỘNG");
        tLabel.setCellStyle(s.totalLabel);

        XSSFCell tTotal = totRow.createCell(1);
        tTotal.setCellValue(total);
        tTotal.setCellStyle(s.totalLabel);

        XSSFCell tPct = totRow.createCell(2);
        tPct.setCellValue("100%");
        tPct.setCellStyle(s.totalLabel);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Helper methods
    // ─────────────────────────────────────────────────────────────────────────

    /** Write merged title row, returns next row index. */
    private static int writeTitleRow(XSSFSheet sheet, Styles s, int rowIdx, String title, int cols) {
        XSSFRow row = sheet.createRow(rowIdx);
        row.setHeight((short) 700);
        XSSFCell cell = row.createCell(0);
        cell.setCellValue(title);
        cell.setCellStyle(s.title);
        if (cols > 1) sheet.addMergedRegion(new CellRangeAddress(rowIdx, rowIdx, 0, cols - 1));
        return rowIdx + 1;
    }

    private static void writeSubtitleRow(XSSFSheet sheet, Styles s, int rowIdx, String text, int cols) {
        XSSFRow row = sheet.createRow(rowIdx);
        XSSFCell cell = row.createCell(0);
        cell.setCellValue(text);
        cell.setCellStyle(s.subtitle);
        if (cols > 1) sheet.addMergedRegion(new CellRangeAddress(rowIdx, rowIdx, 0, cols - 1));
    }

    private static void writeKpiRow(XSSFSheet sheet, Styles s, int rowIdx, String label, String value, boolean isSection) {
        XSSFRow row = sheet.createRow(rowIdx);
        XSSFCell cLabel = row.createCell(0);
        cLabel.setCellValue(label);
        cLabel.setCellStyle(isSection ? s.kpiSection : s.kpiLabel);

        if (value != null) {
            XSSFCell cValue = row.createCell(1);
            cValue.setCellValue(value);
            cValue.setCellStyle(s.kpiValue);
        } else if (isSection) {
            sheet.addMergedRegion(new CellRangeAddress(rowIdx, rowIdx, 0, 1));
        }
    }

    private static void createHeaderCell(XSSFRow row, Styles s, int col, String label) {
        XSSFCell cell = row.createCell(col);
        cell.setCellValue(label);
        cell.setCellStyle(s.header);
    }

    private static String fmtVnd(long value) {
        return String.format("%,d ₫", value).replace(',', '.');
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Inner class: shared cell styles
    // ─────────────────────────────────────────────────────────────────────────

    private static class Styles {
        final XSSFCellStyle title;
        final XSSFCellStyle subtitle;
        final XSSFCellStyle header;
        final XSSFCellStyle kpiSection;
        final XSSFCellStyle kpiLabel;
        final XSSFCellStyle kpiValue;
        final XSSFCellStyle dataEven;
        final XSSFCellStyle dataOdd;
        final XSSFCellStyle moneyEven;
        final XSSFCellStyle moneyOdd;
        final XSSFCellStyle totalLabel;
        final XSSFCellStyle totalMoney;

        Styles(XSSFWorkbook wb) {
            XSSFFont fontBold = wb.createFont();
            fontBold.setBold(true);
            fontBold.setFontHeightInPoints((short) 13);
            fontBold.setColor(new XSSFColor(COLOR_TITLE_FG, null));

            XSSFFont fontBoldDark = wb.createFont();
            fontBoldDark.setBold(true);
            fontBoldDark.setFontHeightInPoints((short) 11);
            fontBoldDark.setColor(new XSSFColor(COLOR_PRIMARY, null));

            XSSFFont fontNormal = wb.createFont();
            fontNormal.setFontHeightInPoints((short) 10);

            XSSFFont fontBoldNormal = wb.createFont();
            fontBoldNormal.setBold(true);
            fontBoldNormal.setFontHeightInPoints((short) 10);

            XSSFFont fontHeaderWhite = wb.createFont();
            fontHeaderWhite.setBold(true);
            fontHeaderWhite.setFontHeightInPoints((short) 10);
            fontHeaderWhite.setColor(new XSSFColor(COLOR_TITLE_FG, null));

            // ── title ──
            title = wb.createCellStyle();
            title.setFillForegroundColor(new XSSFColor(COLOR_PRIMARY, null));
            title.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            title.setFont(fontBold);
            title.setAlignment(HorizontalAlignment.CENTER);
            title.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorder(title, BorderStyle.THIN);

            // ── subtitle ──
            subtitle = wb.createCellStyle();
            subtitle.setFillForegroundColor(new XSSFColor(new byte[]{(byte)0xF8,(byte)0xF8,(byte)0xF8}, null));
            subtitle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            subtitle.setFont(fontNormal);
            subtitle.setAlignment(HorizontalAlignment.CENTER);
            setBorder(subtitle, BorderStyle.THIN);

            // ── header ──
            header = wb.createCellStyle();
            header.setFillForegroundColor(new XSSFColor(COLOR_HEADER_BG, null));
            header.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            header.setFont(fontHeaderWhite);
            header.setAlignment(HorizontalAlignment.CENTER);
            setBorder(header, BorderStyle.THIN);

            // ── kpiSection ──
            kpiSection = wb.createCellStyle();
            kpiSection.setFillForegroundColor(new XSSFColor(new byte[]{(byte)0xF3,(byte)0xF4,(byte)0xF6}, null));
            kpiSection.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            kpiSection.setFont(fontBoldNormal);
            setBorder(kpiSection, BorderStyle.THIN);

            // ── kpiLabel ──
            kpiLabel = wb.createCellStyle();
            kpiLabel.setFont(fontNormal);
            setBorder(kpiLabel, BorderStyle.THIN);

            // ── kpiValue ──
            kpiValue = wb.createCellStyle();
            kpiValue.setFont(fontBoldDark);
            kpiValue.setAlignment(HorizontalAlignment.RIGHT);
            setBorder(kpiValue, BorderStyle.THIN);

            // ── dataEven / dataOdd ──
            dataEven = wb.createCellStyle();
            dataEven.setFont(fontNormal);
            setBorder(dataEven, BorderStyle.THIN);

            dataOdd = wb.createCellStyle();
            dataOdd.setFillForegroundColor(new XSSFColor(COLOR_ROW_ALT, null));
            dataOdd.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            dataOdd.setFont(fontNormal);
            setBorder(dataOdd, BorderStyle.THIN);

            // ── moneyEven / moneyOdd ──
            DataFormat df = wb.createDataFormat();
            short moneyFmt = df.getFormat("#,##0");

            moneyEven = wb.createCellStyle();
            moneyEven.cloneStyleFrom(dataEven);
            moneyEven.setDataFormat(moneyFmt);
            moneyEven.setAlignment(HorizontalAlignment.RIGHT);

            moneyOdd = wb.createCellStyle();
            moneyOdd.cloneStyleFrom(dataOdd);
            moneyOdd.setDataFormat(moneyFmt);
            moneyOdd.setAlignment(HorizontalAlignment.RIGHT);

            // ── totalLabel / totalMoney ──
            totalLabel = wb.createCellStyle();
            totalLabel.setFillForegroundColor(new XSSFColor(COLOR_PRIMARY, null));
            totalLabel.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            totalLabel.setFont(fontHeaderWhite);
            setBorder(totalLabel, BorderStyle.MEDIUM);

            totalMoney = wb.createCellStyle();
            totalMoney.cloneStyleFrom(totalLabel);
            totalMoney.setDataFormat(moneyFmt);
            totalMoney.setAlignment(HorizontalAlignment.RIGHT);
        }

        private static void setBorder(CellStyle cs, BorderStyle style) {
            cs.setBorderTop(style);
            cs.setBorderBottom(style);
            cs.setBorderLeft(style);
            cs.setBorderRight(style);
        }
    }
}
