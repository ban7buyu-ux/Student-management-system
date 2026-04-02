package com.sms.controller;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Date;

@Controller
public class ExportController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/export/results")
    public void exportStudentResults(HttpSession session, HttpServletResponse response) throws IOException {
        String email = (String) session.getAttribute("email");
        if (email == null) {
            response.sendRedirect("/");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=results_" + email + ".pdf");

        try (Document document = new Document(PageSize.A4)) {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Font Styles
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font headFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

            // Title
            Paragraph title = new Paragraph("Academic Performance Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Student Info
            document.add(new Paragraph("Student Email: " + email, normalFont));
            document.add(new Paragraph("Date: " + new Date().toString(), normalFont));
            document.add(new Paragraph(" ", normalFont)); // Spacing

            // Table
            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100f);
            table.setWidths(new float[] {3, 1, 1});

            PdfPCell hcell;
            hcell = new PdfPCell(new Phrase("Subject Name", headFont));
            hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(hcell);

            hcell = new PdfPCell(new Phrase("Marks", headFont));
            hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(hcell);

            hcell = new PdfPCell(new Phrase("Grade", headFont));
            hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(hcell);

            List<Map<String, Object>> results = jdbcTemplate.queryForList(
                "SELECT subject_name, marks, grade FROM results WHERE email = ?", email);

            for (Map<String, Object> row : results) {
                table.addCell(new Phrase(row.get("subject_name").toString(), normalFont));
                table.addCell(new Phrase(row.get("marks").toString(), normalFont));
                table.addCell(new Phrase(row.get("grade").toString(), normalFont));
            }

            document.add(table);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }

    @GetMapping("/export/all_marks")
    public void exportAllMarks(HttpSession session, HttpServletResponse response) throws IOException {
        String role = (String) session.getAttribute("role");
        if (!"admin".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=all_student_marks.pdf");

        try (Document document = new Document(PageSize.A4)) {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font headFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10);

            Paragraph title = new Paragraph("University-Wide Academic Records", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100f);

            String[] headers = {"Student Email", "Subject", "Marks", "Grade"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headFont));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBackgroundColor(java.awt.Color.LIGHT_GRAY);
                table.addCell(cell);
            }

            List<Map<String, Object>> results = jdbcTemplate.queryForList(
                "SELECT email, subject_name, marks, grade FROM results ORDER BY email ASC");

            for (Map<String, Object> row : results) {
                table.addCell(new Phrase(row.get("email").toString(), normalFont));
                table.addCell(new Phrase(row.get("subject_name").toString(), normalFont));
                table.addCell(new Phrase(row.get("marks").toString(), normalFont));
                table.addCell(new Phrase(row.get("grade").toString(), normalFont));
            }

            document.add(table);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}
