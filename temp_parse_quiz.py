import json
import re

def parse_questions(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    questions = []
    current_difficulty = 'medium' # Default
    current_question = None
    current_options = []
    current_correct = None
    
    # regex for options: a) ... or b) ...
    option_re = re.compile(r'^([a-z])\)\s*(.*)')

    question_buffer = []

    def save_question():
        nonlocal current_question, current_options, current_correct, question_buffer
        if current_question:
            # Clean up question text from buffer
            q_text = "\n".join(question_buffer).strip()
            
            # If still no correct answer found but we have checked markers
            # Handle the checkmark detection in options loop
            
            # Map difficulty headers
            diff = current_difficulty
            
            cleaned_options = []
            final_correct = ""
            
            for index, (opt_text, is_correct) in enumerate(current_options):
                cleaned_options.append(opt_text)
                if is_correct:
                    final_correct = opt_text

            questions.append({
                "question": q_text,
                "options": cleaned_options,
                "correct": final_correct,
                "difficulty": diff
            })
        
        current_question = None
        current_options = []
        current_correct = None
        question_buffer = []

    for line in lines:
        line = line.strip()
        if not line:
            continue

        # Check for difficulty headers
        if "Très facile / Facile" in line:
            save_question()
            current_difficulty = 'easy'
            continue
        elif "Niveau Moyen" in line:
            save_question()
            current_difficulty = 'medium'
            continue
        elif "QCM Très Difficile" in line:
            save_question()
            current_difficulty = 'hard'
            continue
        
        # Check if line is an option
        match = option_re.match(line)
        if match:
            # It's an option
            opt_char = match.group(1)
            opt_text = match.group(2)
            is_correct = False
            if '✅' in opt_text:
                is_correct = True
                opt_text = opt_text.replace('✅', '').strip()
            
            current_options.append((opt_text, is_correct))
        else:
            # It's part of a question
            # If we were collecting options, this means a NEW question starts
            if current_options:
                save_question()
                question_buffer.append(line)
                current_question = True
            else:
                # Continuing a question or starting first one
                question_buffer.append(line)
                current_question = True

    # Save last question
    save_question()

    return questions

questions = parse_questions('temp_questions_input.txt')
print(json.dumps(questions, indent=4, ensure_ascii=False))
