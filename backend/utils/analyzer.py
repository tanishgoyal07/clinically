from .generator import extract_summary_and_key_terms, extract_text_from_image, extract_text_from_pdf, create_pdf_report
import os

def process_medical_report(paths, output_path):
    try:
        text = ""
        if isinstance(paths, list):
            if all(p.lower().endswith(('.png', '.jpg', '.jpeg')) for p in paths):
                extracted = extract_text_from_image(paths)
                text = "\n".join(extracted.values())
            elif len(paths) == 1 and paths[0].lower().endswith('.pdf'):
                text = extract_text_from_pdf(paths[0])
            else:
                return False, "Unsupported or mixed file types."
        else:
            return False, "Unsupported input type."

        if not text.strip():
            return False, "No text extracted."

        summary = extract_summary_and_key_terms(text)
        logo_path = "logo.png"  # Ensure logo is present
        create_pdf_report(output_path, summary, logo_path)
        return True, None
    except Exception as e:
        return False, str(e)
