# HƯỚNG DẪN CHUYỂN FILE MARKDOWN SANG WORD

## Cách 1: Sử dụng Pandoc (Khuyến nghị)

### Bước 1: Cài đặt Pandoc
- Tải tại: https://pandoc.org/installing.html
- Hoặc dùng chocolatey (Windows): `choco install pandoc`

### Bước 2: Chuyển đổi
```bash
pandoc BAO_CAO_DU_AN.md -o BAO_CAO_DU_AN.docx
```

### Bước 3: Tùy chỉnh (nếu cần)
```bash
# Với reference document (template)
pandoc BAO_CAO_DU_AN.md -o BAO_CAO_DU_AN.docx --reference-doc=template.docx

# Với table of contents
pandoc BAO_CAO_DU_AN.md -o BAO_CAO_DU_AN.docx --toc
```

---

## Cách 2: Copy/Paste trực tiếp

### Bước 1: Mở file BAO_CAO_DU_AN.md
- Dùng VS Code, Notepad++, hoặc text editor bất kỳ

### Bước 2: Copy toàn bộ nội dung

### Bước 3: Paste vào Word
- Mở Microsoft Word
- Paste (Ctrl+V)
- Word sẽ tự động format markdown

### Bước 4: Format lại
- Heading 1: Dòng bắt đầu bằng `#`
- Heading 2: Dòng bắt đầu bằng `##`
- Code block: Phần trong ``` ```
- Bold: Phần trong `**text**`

---

## Cách 3: Sử dụng Online Converter

### Các trang web:
1. **Dillinger.io**
   - Vào: https://dillinger.io/
   - Paste markdown vào bên trái
   - Export → Word

2. **Markdown to Word**
   - Vào: https://www.markdowntoword.com/
   - Upload file hoặc paste
   - Download Word

3. **CloudConvert**
   - Vào: https://cloudconvert.com/md-to-docx
   - Upload file .md
   - Convert và download

---

## Cách 4: Sử dụng VS Code Extension

### Bước 1: Cài extension
- Mở VS Code
- Tìm extension: "Markdown PDF" hoặc "Markdown All in One"

### Bước 2: Export
- Mở file BAO_CAO_DU_AN.md
- Ctrl+Shift+P → "Markdown: Export (docx)"

---

## Tips để file Word đẹp hơn

### 1. Thêm trang bìa
```
TRƯỜNG ĐẠI HỌC ...
KHOA CÔNG NGHỆ THÔNG TIN

---

BÀI TẬP LỚN MÔN ...

ỨNG DỤNG CHIA SẺ ẢNH
PHOTO SHARE APP

---

Sinh viên thực hiện: [Tên]
MSSV: [Mã số]
Lớp: [Lớp]

Giảng viên hướng dẫn: [Tên GV]

---

Thành phố, Tháng Năm
```

### 2. Thêm mục lục tự động
- Word → References → Table of Contents → Automatic

### 3. Format code đẹp
- Chọn code block
- Font: Consolas hoặc Courier New
- Background: Light gray
- Border: Thin border

### 4. Thêm số trang
- Insert → Page Number → Bottom of Page

### 5. Thêm header/footer
- Insert → Header/Footer
- Thêm tên đồ án, tên sinh viên

---

## Checklist trước khi nộp

- [ ] Đã có trang bìa
- [ ] Đã có mục lục
- [ ] Heading đã format đúng
- [ ] Code block dễ đọc
- [ ] Có số trang
- [ ] Đã kiểm tra lỗi chính tả
- [ ] Hình ảnh (nếu có) rõ nét
- [ ] File PDF (nếu yêu cầu)

---

## Xuất PDF từ Word

1. File → Save As
2. Chọn "PDF" trong dropdown
3. Save

Hoặc:

1. File → Export
2. Create PDF/XPS Document
3. Publish

---

**Lưu ý:** Nên giữ cả file .md gốc để dễ chỉnh sửa sau này!
