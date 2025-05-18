import os
from dotenv import load_dotenv
load_dotenv() 

import pytesseract
from PIL import Image
from PyPDF2 import PdfReader
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.utils import ImageReader
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY
from reportlab.lib import colors
import google.generativeai as genai

genai.configure(api_key="AIzaSyACpYhb50hhs9YLamXKStSA_pTZuh756jQ")
# genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

def extract_text_from_pdf(pdf_path):
    text = ""
    try:
        reader = PdfReader(pdf_path)
        for page in reader.pages:
            text += page.extract_text() or ""
    except Exception as e:
        text = f"Error reading PDF: {e}"
    return text

def extract_text_from_image(image_paths):
    extracted = {}
    for img_path in image_paths:
        try:
            image = Image.open(img_path)
            text = pytesseract.image_to_string(image)
            extracted[os.path.basename(img_path)] = text
        except Exception as e:
            extracted[os.path.basename(img_path)] = f"Error: {e}"
    return extracted

def extract_summary_and_key_terms(text):
    prompt = f"Summarize and explain the following medical document. Also create seperate heading to explain all difficult medical terms present in image very briefly but in simple language. Give in depth summary and other headings such as at home cures which are not something risky but known ways such as suggested foods and diets. Ensure to add warning to seek medical professional advice before following any advice. If the text is not relevant to any medical report or is not related to medical information, decline providing the information very politely and ask user to upload health, fitness, medical reports or medicine related docs only. Properly format with both headings and key pointers and general paragraphs. Do not mention any names of doctors, patients, etc. Try to not use your own knowledge and reply mostly from pdf. Here is the text to summarize: \n\n {text}"
    model = genai.GenerativeModel("gemini-1.5-flash")
    response = model.generate_content(prompt)
    return response.text.strip()

def create_pdf_report(output_path, explanation_text, logo_path):
    # Document setup -> A4 Sheet with margins 
    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        rightMargin=40,
        leftMargin=40,
        topMargin=80,
        bottomMargin=50
    )

    # Styles
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle('CenterTitle', alignment=TA_CENTER, fontSize=18, spaceAfter=30))
    styles.add(ParagraphStyle('Justify', alignment=TA_JUSTIFY, leading=16))
    styles.add(ParagraphStyle('SubHeading', fontSize=14, spaceBefore=12, spaceAfter=6, leading=16))

    flowables = []

    # Heading
    flowables.append(Paragraph("<b>Clinically – Medical Report Analyzer</b>", styles['CenterTitle']))
    flowables.append(Spacer(1, 12))  # Extra space after heading

    # Format the text
    for orig in explanation_text.splitlines():
        line = orig.strip()
        if not line:
            flowables.append(Spacer(1, 8))
            continue

        clean = line.replace('*', '').strip()

        if clean.endswith(':') and not orig.lstrip().startswith('*'):
            flowables.append(Paragraph(f"<b>{clean}</b>", styles['SubHeading']))
        elif orig.lstrip().startswith('*'):
            if ':' in clean:
                term, expl = clean.split(':', 1)
                flowables.append(Paragraph(f"• <b>{term.strip()}:</b> {expl.strip()}", styles['Justify']))
            else:
                flowables.append(Paragraph(f"• {clean}", styles['Justify']))
        else:
            flowables.append(Paragraph(clean, styles['Justify']))

    flowables.append(PageBreak())

    # Watermark logo
    def draw_header(c: canvas.Canvas, doc):
        width, height = A4

        # Draw watermark-style logo
        if os.path.exists(logo_path):
            watermark_width = 4 * inch
            watermark_height = 4 * inch
            c.saveState()
            c.translate((width - watermark_width) / 2, (height - watermark_height) / 2)
            c.setFillAlpha(0.2) 
            c.drawImage(
                logo_path,
                0,
                0,
                width=watermark_width,
                height=watermark_height,
                mask='auto'
            )
            c.restoreState()

    # --- Build PDF ---
    doc.build(flowables, onFirstPage=draw_header, onLaterPages=draw_header)
    print(f"PDF successfully saved at: {output_path}")
