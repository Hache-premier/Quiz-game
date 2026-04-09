#!/bin/bash

QUESTIONS_FILE="questions.txt"
HIGHSCORES_FILE="highscores.txt"
QUESTIONS=()
MODE="normal"

usage() {
    echo -e "Quiz Game Usage:"
    echo "  ./quiz.sh           - Play normal mode (scores saved)"
    echo "  ./quiz.sh practice  - Play practice mode (no scores)"
    echo "  ./quiz.sh highscores - View top 5 high scores"
    exit 0
}

load_questions() {
    if [[ ! -f "$QUESTIONS_FILE" ]]; then
        echo -e "Error: Questions file '$QUESTIONS_FILE' not found!${NC}"
        exit 1
    fi
    
    if [[ ! -s "$QUESTIONS_FILE" ]]; then
        echo -e "Error: Questions file '$QUESTIONS_FILE' is empty!"
        exit 1
    fi
    
    local line_num=0
    while IFS='|' read -r question opt_a opt_b opt_c opt_d correct; do
        if [[ -z "$question" ]]; then
            continue
        fi
        
        if [[ -n "$question" && -n "$opt_a" && -n "$opt_b" && -n "$opt_c" && -n "$opt_d" && -n "$correct" ]]; then
            QUESTIONS+=("$question|$opt_a|$opt_b|$opt_c|$opt_d|$correct")
            ((line_num++))
        else
            echo -e "${YELLOW}Warning: Skipping malformed line: $question|$opt_a|$opt_b|$opt_c|$opt_d|$correct${NC}"
        fi
    done < "$QUESTIONS_FILE"
    
    if [[ ${#QUESTIONS[@]} -eq 0 ]]; then
        echo -e "${RED}Error: No valid questions found in '$QUESTIONS_FILE'!${NC}"
        exit 1
    fi
    
    echo -e "Loaded ${#QUESTIONS[@]} questions successfully."
}

shuffle_questions() {
    mapfile -t QUESTIONS < <(printf "%s\n" "${QUESTIONS[@]}" | shuf)
}

display_question() {
    local question_num=$1
    local total=$2
    local question_data=$3
    
    IFS='|' read -r question opt_a opt_b opt_c opt_d correct <<< "$question_data"
    
    echo -e "############################################################"
    echo -e "Question $question_num of $total"
    echo -e "$question"
    echo ""
    echo -e "  $opt_a"
    echo -e "  $opt_b"
    echo -e "  $opt_c"
    echo -e "  $opt_d"
    echo ""
    echo -e -n "Your answer (A/B/C/D):"
}

validate_answer() {
    local answer=$1
    answer=$(echo "$answer" | tr '[:lower:]' '[:upper:]')
    if [[ "$answer" =~ ^[ABCD]$ ]]; then
        return 0
    else
        return 1
    fi
}

play_normal() {
    local username
    echo -e "########################################################"
    echo -e "Welcome to the Quiz Game!"
    echo -e "########################################################"
    echo -e -n "Please enter your username: "
    read -r username
    
    while [[ -z "$username" ]]; do
        echo -e "Username cannot be empty!"
        echo -e -n "Please enter your username: "
        read -r username
    done
    
    local total_questions=${#QUESTIONS[@]}
    local correct=0
    local incorrect=0
    local current_streak=0
    local longest_streak=0
    
    shuffle_questions
    for i in "${!QUESTIONS[@]}"; do
        clear
        
        display_question $((i+1)) $total_questions "${QUESTIONS[$i]}"
        
        IFS='|' read -r _ _ _ _ _ correct_answer <<< "${QUESTIONS[$i]}"
        
        local user_answer
        while true; do
            read -r user_answer
            if validate_answer "$user_answer"; then
                break
            else
                echo -e -n "Invalid input! Please enter A, B, C, or D: "
            fi
        done
        
        user_answer=$(echo "$user_answer" | tr '[:lower:]' '[:upper:]')
        
        if [[ "$user_answer" == "$correct_answer" ]]; then
            echo -e "✓ Correct!"
            ((correct++))
            ((current_streak++))
            if [[ $current_streak -gt $longest_streak ]]; then
                longest_streak=$current_streak
            fi
        else
            echo -e "✗ Incorrect! The correct answer was $correct_answer"
            ((incorrect++))
            current_streak=0
        fi
        
        if [[ $((i+1)) -lt $total_questions ]]; then
            echo ""
            echo -e "Press Enter to continue..."
            read -r
        fi
    done
    
    local final_score=0
    if [[ $total_questions -gt 0 ]]; then
        final_score=$((correct * 100 / total_questions))
    fi
    
    echo ""
    echo -e "########################################################"
    echo -e "Game Over! Final Results:"
    echo -e "########################################################"
    echo -e "Correct_Answers:        $correct$"
    echo -e "Incorrect_Answers:      $incorrect"
    echo -e "Longest streak: $longest_streak"
    echo -e "Final score:    ${final_score}%"
    echo -e "########################################################"
    
    local date=$(date "+%Y-%m-%d")
    echo "$username|$final_score|$correct/$total_questions|$date" >> "$HIGHSCORES_FILE"
    echo -e "Score saved to highscores!"
}

play_practice() {
    local total_questions=${#QUESTIONS[@]}
    echo -e "########################################################"
    echo -e "Welcome to Practice Mode!"
    echo -e "In this mode, you'll see the correct answer immediately."
    echo -e "########################################################"
    echo -e "Press Enter to start..."
    read -r
    
    shuffle_questions
    for i in "${!QUESTIONS[@]}"; do
        clear

        display_question $((i+1)) $total_questions "${QUESTIONS[$i]}"
        
        IFS='|' read -r _ _ _ _ _ correct_answer <<< "${QUESTIONS[$i]}"
        
        local user_answer
        while true; do
            read -r user_answer
            if validate_answer "$user_answer"; then
                break
            else
                echo -e -n "Invalid input! Please enter A, B, C, or D: "
            fi
        done
        
        user_answer=$(echo "$user_answer" | tr '[:lower:]' '[:upper:]')
        
        if [[ "$user_answer" == "$correct_answer" ]]; then
            echo -e "Correct! ✓"
        else
            echo -e "Incorrect! The correct answer was ${correct_answer})"
        fi
        
        if [[ $((i+1)) -lt $total_questions ]]; then
            echo "                           "
            echo -e "Press Enter to continue..."
            read -r
        fi
    done
    
    echo ""
    echo -e "#########################################################"
    echo -e "Practice session completed!"
    echo -e "#########################################################"
}

show_highscores() {
    if [[ ! -f "$HIGHSCORES_FILE" ]] || [[ ! -s "$HIGHSCORES_FILE" ]]; then
        echo -e "No high scores yet! Play the game to create some."
        return
    fi
    
    echo -e "###########################################################"
    echo -e "Top 5 High Scores"
    echo -e "###########################################################"
    
    sort -t'|' -k2 -rn "$HIGHSCORES_FILE" | head -5 | while IFS='|' read -r username score details date; do
        printf "%-15s %3d%% %-10s %s\n" "$username" "$score" "$details" "$date"
    done
    
    echo -e "############################################################"
}
# The main function to handle arguments and start the game
main() {
    case "$1" in
        practice)
            MODE="practice"
            ;;
        highscores)
            load_questions
            show_highscores
            exit 0
            ;;
        ""|normal)
            MODE="normal"
            ;;
        *)
            usage
            ;;
    esac
    
    load_questions
    
    if [[ "$MODE" == "practice" ]]; then
        play_practice
    else
        play_normal
    fi
}

main "$@"