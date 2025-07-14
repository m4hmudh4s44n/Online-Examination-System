#!/bin/bash
# QuickQuiz: Online Exam System (Multi-Subject)
# Author: Complete Implementation
# Features: Registration, Login, Timed Exams, Auto-Grading, Admin Dashboard

# --- Configuration ---
STUDENT_DB="students.db"
RESULTS_DB="results.db"
EXAM_DB="exams.db"
QUESTIONS_DB="questions.db"
ADMIN_DB="admin.db"
CURRENT_USER=""
CURRENT_ADMIN="admin"

# --- Setup ---
touch "$STUDENT_DB" "$RESULTS_DB" "$EXAM_DB" "$QUESTIONS_DB" "$ADMIN_DB"

# Initialize admin if not exists
if [[ ! -s "$ADMIN_DB" ]]; then
    echo "admin|admin123|Administrator|admin@quiz.com" > "$ADMIN_DB"
fi

# --- Color Codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# --- Utility Functions ---
function show_header {
    clear
    echo -e "${CYAN}═══════════════════════════════════════════════════"
    echo -e "        QuickQuiz Online Exam System v2.0"
    echo -e "═══════════════════════════════════════════════════${NC}"
}

function press_enter {
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read -r < /dev/tty
}

function loading_animation {
    echo -n "Processing"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo " Done!"
    sleep 1
}

# --- Validation Functions ---
function validate_email {
    local email="$1"
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

function validate_phone {
    local phone="$1"
    if [[ "$phone" =~ ^[0-9]{10,15}$ ]]; then
        return 0
    else
        return 1
    fi
}

# --- Main Menu ---
function main_menu {
    show_header
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│                  MAIN MENU                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│  ${CYAN}1.${WHITE} Admin Login                              │"
    echo -e "│  ${CYAN}2.${WHITE} Student Registration                     │"
    echo -e "│  ${CYAN}3.${WHITE} Student Login                            │"
    echo -e "│  ${CYAN}4.${WHITE} Student Profile                          │"
    echo -e "│  ${CYAN}5.${WHITE} Forgot Password                          │"
    echo -e "│  ${CYAN}6.${WHITE} Exit                                     │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
    echo -e "\n${YELLOW}Enter your choice: ${NC}"
    read choice
   
    case "$choice" in
        1) admin_login ;;
        2) student_registration ;;
        3) student_login ;;
        4) student_profile ;;
        5) forgot_password ;;
        6) exit_system ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1; main_menu ;;
    esac
}

# --- Admin Functions ---
function admin_login {
    local FIXED_ADMIN_PASSWORD="admin123"

    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│                 ADMIN LOGIN                  │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -ne "\n${CYAN}Username: ${NC}"
    read username
    echo -ne "${CYAN}Password: ${NC}"
    read -s password
    echo
   
    # Check username and password
    if [[ "$username" == "admin" && "$password" == "$FIXED_ADMIN_PASSWORD" ]]; then
        CURRENT_ADMIN="$username"
        echo -e "${GREEN}Login successful!${NC}"
        loading_animation
        admin_dashboard
    else
        echo -e "${RED}Invalid credentials!${NC}"
        press_enter
        main_menu
    fi
}

function admin_dashboard {
    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│                ADMIN DASHBOARD               │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│  Welcome, ${CURRENT_ADMIN}!                             │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│  ${CYAN}1.${WHITE} Manage Exams                             │"
    echo -e "│  ${CYAN}2.${WHITE} View All Students                        │"
    echo -e "│  ${CYAN}3.${WHITE} Search Students                          │"
    echo -e "│  ${CYAN}4.${WHITE} View Results & Statistics                │"
    echo -e "│  ${CYAN}5.${WHITE} Change Password                          │"
    echo -e "│  ${CYAN}6.${WHITE} System Statistics                        │"
    echo -e "│  ${CYAN}7.${WHITE} Logout                                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${YELLOW}Enter your choice: ${NC}"
    read choice
   
    case "$choice" in
        1) manage_exams ;;
        2) view_all_students ;;
        3) search_students_by_specific_field ;;
        4) view_results_statistics ;;
        5) change_admin_password ;;
        6) system_statistics ;;
        7) admin_logout ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1; admin_dashboard ;;
    esac
}

function manage_exams {
    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│                 MANAGE EXAMS                 │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│  ${CYAN}1.${WHITE} Create New Exam                          │"
    echo -e "│  ${CYAN}2.${WHITE} View All Exams                           │"
    echo -e "│  ${CYAN}3.${WHITE} Update Exam                              │"
    echo -e "│  ${CYAN}4.${WHITE} Delete Exam                              │"
    echo -e "│  ${CYAN}5.${WHITE} Back to Dashboard                        │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${YELLOW}Enter your choice: ${NC}"
    read choice
   
    case "$choice" in
        1) create_exam ;;
        2) view_all_exams ;;
        3) update_exam ;;
        4) delete_exam ;;
        5) admin_dashboard ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1; manage_exams ;;
    esac
}

function create_exam {
    show_header
    echo -e "${GREEN}┌──────────────────────────────────────────────┐"
    echo -e "│               CREATE NEW EXAM                │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Exam Name: ${NC}"
    read exam_name
    echo -e "${CYAN}Subject: ${NC}"
    read subject
    echo -e "${CYAN}Duration (minutes): ${NC}"
    read duration
    echo -e "${CYAN}Total Marks: ${NC}"
    read total_marks
    echo -e "${CYAN}Passing Marks: ${NC}"
    read passing_marks
    echo -e "${CYAN}Number of Questions: ${NC}"
    read num_questions
   
    # Generate exam ID (starting from 1 and incrementing)
    if [[ -s "$EXAM_DB" ]]; then
        # Find the highest existing exam ID and add 1
        local max_id=$(cut -d'|' -f1 "$EXAM_DB" | sort -n | tail -1)
        exam_id=$((max_id + 1))
    else
        # If no exams exist, start with ID 1
        exam_id=1
    fi
   
    # Create exam entry in database
    echo "$exam_id|$exam_name|$subject|$duration|$total_marks|$passing_marks|$num_questions" >> "$EXAM_DB"
   
    echo -e "\n${YELLOW}Now enter the questions:${NC}"
    for ((i=1; i<=num_questions; i++)); do
        echo -e "\n${CYAN}Question $i: ${NC}"
        read question
        echo -e "${CYAN}Option A: ${NC}"
        read opt_a
        echo -e "${CYAN}Option B: ${NC}"
        read opt_b
        echo -e "${CYAN}Option C: ${NC}"
        read opt_c
        echo -e "${CYAN}Option D: ${NC}"
        read opt_d
        echo -e "${CYAN}Correct Answer (A/B/C/D): ${NC}"
        read correct_answer
        echo -e "${CYAN}Marks for this question: ${NC}"
        read marks
       
        # Store question in questions database: exam_id|question_num|question|opt_a|opt_b|opt_c|opt_d|correct_answer|marks
        echo "$exam_id|$i|$question|$opt_a|$opt_b|$opt_c|$opt_d|$correct_answer|$marks" >> "$QUESTIONS_DB"
    done
   
    echo -e "\n${GREEN}Exam created successfully!${NC}"
    press_enter
    manage_exams
}

function view_all_exams {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│                  ALL EXAMS                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"

    if [[ -s "$EXAM_DB" ]]; then
        echo
        printf "${CYAN}%-5s %-12s %-20s %-10s %-5s${NC}\n" "ID" "Name" "Subject" "Duration" "Marks"
        printf "${CYAN}---------------------------------------------------------------${NC}\n"

        while IFS='|' read -r id name subject duration total_marks passing_marks num_questions; do
            printf "${WHITE}%-5s %-12s %-20s %-10s %-5s${NC}\n" "$id" "$name" "$subject" "${duration}min" "$total_marks"
        done < "$EXAM_DB"
    else
        echo -e "\n${RED}No exams found!${NC}"
    fi

    press_enter
    manage_exams
}


function update_exam {
    show_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│                 UPDATE EXAM                  │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Enter Exam ID to update: ${NC}"
    read exam_id
   
    if grep -q "^$exam_id|" "$EXAM_DB"; then
        echo -e "${GREEN}Exam found! Enter new details:${NC}"
       
        echo -e "\n${CYAN}New Exam Name: ${NC}"
        read new_name
        echo -e "${CYAN}New Subject: ${NC}"
        read new_subject
        echo -e "${CYAN}New Duration (minutes): ${NC}"
        read new_duration
        echo -e "${CYAN}New Total Marks: ${NC}"
        read new_total_marks
        echo -e "${CYAN}New Passing Marks: ${NC}"
        read new_passing_marks
       
        # Update exam in database
        sed -i "s/^$exam_id|.*/$exam_id|$new_name|$new_subject|$new_duration|$new_total_marks|$new_passing_marks/" "$EXAM_DB"
       
        echo -e "\n${GREEN}Exam updated successfully!${NC}"
    else
        echo -e "\n${RED}Exam not found!${NC}"
    fi
   
    press_enter
    manage_exams
}

function delete_exam {
    show_header
    echo -e "${RED}┌──────────────────────────────────────────────┐"
    echo -e "│                 DELETE EXAM                  │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Enter Exam ID to delete: ${NC}"
    read exam_id
   
    if grep -q "^$exam_id|" "$EXAM_DB"; then
        echo -e "${YELLOW}Are you sure you want to delete this exam? (y/n): ${NC}"
        read confirm
       
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            sed -i "/^$exam_id|/d" "$EXAM_DB"
            # Also delete all questions for this exam
            sed -i "/^$exam_id|/d" "$QUESTIONS_DB"
            echo -e "\n${GREEN}Exam deleted successfully!${NC}"
        else
            echo -e "\n${YELLOW}Deletion cancelled.${NC}"
        fi
    else
        echo -e "\n${RED}Exam not found!${NC}"
    fi
   
    press_enter
    manage_exams
}

function view_all_students {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│              ALL STUDENTS DATA               │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ -s "$STUDENT_DB" ]]; then
        echo -e "\n${CYAN}Student Details:${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
       
        while IFS='|' read -r username student_id full_name level term email phone sex password; do
            echo -e "${WHITE}Username: ${CYAN}$username${NC}"
            echo -e "${WHITE}Student ID: ${CYAN}$student_id${NC}"
            echo -e "${WHITE}Full Name: ${CYAN}$full_name${NC}"
            echo -e "${WHITE}Level: ${CYAN}$level${NC}"
            echo -e "${WHITE}Term: ${CYAN}$term${NC}"
            echo -e "${WHITE}Email: ${CYAN}$email${NC}"
            echo -e "${WHITE}Phone: ${CYAN}$phone${NC}"
            echo -e "${WHITE}Gender: ${CYAN}$sex${NC}"
            echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
        done < "$STUDENT_DB"
    else
        echo -e "\n${RED}No students registered!${NC}"
    fi
   
    press_enter
    admin_dashboard
}

# --- SEARCH STUDENTS (FIXED AND IMPROVED) ---
function search_students_by_specific_field {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│               SEARCH STUDENTS                │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ ! -s "$STUDENT_DB" ]]; then
        echo -e "\n${RED}No students registered!${NC}"
        press_enter
        admin_dashboard
        return
    fi
   
    echo -e "\n${CYAN}Search Options:${NC}"
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│  ${CYAN}1.${WHITE} Search by Student ID                   │"
    echo -e "│  ${CYAN}2.${WHITE} Search by Username                     │"
    echo -e "│  ${CYAN}3.${WHITE} Search by Full Name                    │"
    echo -e "│  ${CYAN}4.${WHITE} Search by Level                        │"
    echo -e "│  ${CYAN}5.${WHITE} Search by Term                         │"
    echo -e "│  ${CYAN}6.${WHITE} Search by Email                        │"
    echo -e "│  ${CYAN}7.${WHITE} Search by Gender                       │"
    echo -e "│  ${CYAN}8.${WHITE} General Search (All Fields)            │"
    echo -e "│  ${CYAN}9.${WHITE} Back to Dashboard                      │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${YELLOW}Enter your choice: ${NC}"
    read search_option
   
    case "$search_option" in
        1) search_by_field "Student ID" 2 ;;
        2) search_by_field "Username" 1 ;;
        3) search_by_field "Full Name" 3 ;;
        4) search_by_field "Level" 4 ;;
        5) search_by_field "Term" 5 ;;
        6) search_by_field "Email" 6 ;;
        7) search_by_field "Gender" 8 ;;
        8) general_search ;;
        9) admin_dashboard ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1; search_students_by_specific_field ;;
    esac
}

function search_by_field {
    local field_name="$1"
    local field_number="$2"

    echo -e "\n${CYAN}Enter $field_name to search: ${NC}"
    read search_term

    if [[ -z "$search_term" ]]; then
        echo -e "${RED}Search term cannot be empty!${NC}"
        press_enter
        search_students_by_specific_field
        return
    fi

    local count=0
    echo -e "\n${GREEN}Search Results for $field_name: \"$search_term\"${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
   
    # Use a more precise search approach
    while IFS='|' read -r username student_id full_name level term email phone sex password; do
        local field_value=""
       
        # Get the correct field value based on field number
        case "$field_number" in
            1) field_value="$username" ;;
            2) field_value="$student_id" ;;
            3) field_value="$full_name" ;;
            4) field_value="$level" ;;
            5) field_value="$term" ;;
            6) field_value="$email" ;;
            7) field_value="$phone" ;;
            8) field_value="$sex" ;;
        esac
       
        # Check if the field contains the search term (case insensitive)
        if [[ "${field_value,,}" == "${search_term,,}" ]]; then
            ((count++))
            echo -e "${WHITE}Result #$count:${NC}"
            echo -e "${WHITE}Username: ${CYAN}$username${NC}"
            echo -e "${WHITE}Student ID: ${CYAN}$student_id${NC}"
            echo -e "${WHITE}Full Name: ${CYAN}$full_name${NC}"
            echo -e "${WHITE}Level: ${CYAN}$level${NC}"
            echo -e "${WHITE}Term: ${CYAN}$term${NC}"
            echo -e "${WHITE}Email: ${CYAN}$email${NC}"
            echo -e "${WHITE}Phone: ${CYAN}$phone${NC}"
            echo -e "${WHITE}Gender: ${CYAN}$sex${NC}"
            echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
        fi
    done < "$STUDENT_DB"
   
    if [[ $count -eq 0 ]]; then
        echo -e "\n${RED}No student found matching '$field_name: $search_term'.${NC}"
    else
        echo -e "\n${GREEN}Total matches found: $count${NC}"
    fi

    press_enter
    search_students_by_specific_field
}

function general_search {
    echo -e "\n${CYAN}Enter search keyword (searches all fields): ${NC}"
    read keyword

    if [[ -z "$keyword" ]]; then
        echo -e "${RED}Search keyword cannot be empty!${NC}"
        press_enter
        search_students_by_specific_field
        return
    fi

    local count=0
    echo -e "\n${GREEN}General Search Results for: \"$keyword\"${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
   
    while IFS='|' read -r username student_id full_name level term email phone sex password; do
        # Check if keyword exists in any field (case insensitive)
        if [[ "${username,,}" == "${keyword,,}" ]] || \
           [[ "${student_id,,}" == "${keyword,,}" ]] || \
           [[ "${full_name,,}" == "${keyword,,}" ]] || \
           [[ "${level,,}" == "${keyword,,}" ]] || \
           [[ "${term,,}" == "${keyword,,}" ]] || \
           [[ "${email,,}" == "${keyword,,}" ]] || \
           [[ "${phone,,}" == "${keyword,,}" ]] || \
           [[ "${sex,,}" == "${keyword,,}" ]]; then
           
            ((count++))
            echo -e "${WHITE}Result #$count:${NC}"
            echo -e "${WHITE}Username: ${CYAN}$username${NC}"
            echo -e "${WHITE}Student ID: ${CYAN}$student_id${NC}"
            echo -e "${WHITE}Full Name: ${CYAN}$full_name${NC}"
            echo -e "${WHITE}Level: ${CYAN}$level${NC}"
            echo -e "${WHITE}Term: ${CYAN}$term${NC}"
            echo -e "${WHITE}Email: ${CYAN}$email${NC}"
            echo -e "${WHITE}Phone: ${CYAN}$phone${NC}"
            echo -e "${WHITE}Gender: ${CYAN}$sex${NC}"
            echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
        fi
    done < "$STUDENT_DB"

    if [[ $count -eq 0 ]]; then
        echo -e "\n${RED}No student found matching General Search: '$keyword'.${NC}"
    else
        echo -e "\n${GREEN}Total matches found: $count${NC}"
    fi

    press_enter
    search_students_by_specific_field
}

function view_results_statistics {
    show_header
    echo -e "${GREEN}┌──────────────────────────────────────────────┐"
    echo -e "│            RESULTS & STATISTICS              │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ -s "$RESULTS_DB" ]]; then
        local total_attempts=$(wc -l < "$RESULTS_DB")
        local passed_count=0
        local failed_count=0
        local total_score=0
       
       printf "${WHITE}%-10s %-6s %-10s %-8s %-20s${NC}\n" "Student" "Exam" "Score" "Status" "Date"
printf "${CYAN}---------------------------------------------------------------${NC}\n"

while IFS='|' read -r student_id exam_id score total_marks status date_time; do
    printf "${WHITE}%-10s %-6s %-10s %-8s %-20s${NC}\n" "$student_id" "$exam_id" "$score/$total_marks" "$status" "$date_time"
    total_score=$((total_score + score))
    if [[ "$status" == "PASSED" ]]; then
        ((passed_count++))
    else
        ((failed_count++))
    fi
done < "$RESULTS_DB"
       
        echo -e "\n${CYAN}Statistics Summary:${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}Total Attempts: $total_attempts${NC}"
        echo -e "${GREEN}Passed: $passed_count${NC}"
        echo -e "${RED}Failed: $failed_count${NC}"
        if [[ $total_attempts -gt 0 ]]; then
            local avg_score=$((total_score / total_attempts))
            local pass_rate=$((passed_count * 100 / total_attempts))
            echo -e "${YELLOW}Average Score: $avg_score${NC}"
            echo -e "${YELLOW}Pass Rate: $pass_rate%${NC}"
        fi
    else
        echo -e "\n${RED}No results found!${NC}"
    fi
   
    press_enter
    admin_dashboard
}

function change_admin_password {
    show_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│             CHANGE ADMIN PASSWORD            │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Current Password: ${NC}"
    read -s current_pass
    echo -e "${CYAN}New Password: ${NC}"
    read -s new_pass
    echo -e "${CYAN}Confirm New Password: ${NC}"
    read -s confirm_pass
    echo
   
    if grep -q "^$CURRENT_ADMIN|$current_pass|" "$ADMIN_DB"; then
        if [[ "$new_pass" == "$confirm_pass" ]]; then
            sed -i "s/^$CURRENT_ADMIN|$current_pass|/$CURRENT_ADMIN|$new_pass|/" "$ADMIN_DB"
            echo -e "\n${GREEN}Password changed successfully!${NC}"
        else
            echo -e "\n${RED}New passwords don't match!${NC}"
        fi
    else
        echo -e "\n${RED}Current password is incorrect!${NC}"
    fi
   
    press_enter
    admin_dashboard
}

function system_statistics {
    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│             SYSTEM STATISTICS                │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    local total_students=$(wc -l < "$STUDENT_DB" 2>/dev/null || echo "0")
    local total_exams=$(wc -l < "$EXAM_DB" 2>/dev/null || echo "0")
    local total_results=$(wc -l < "$RESULTS_DB" 2>/dev/null || echo "0")
   
    echo -e "\n${CYAN}System Overview:${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}📚 Total Students Registered: $total_students${NC}"
    echo -e "${BLUE}📝 Total Exams Created: $total_exams${NC}"
    echo -e "${YELLOW}📊 Total Exam Attempts: $total_results${NC}"
   
    press_enter
    admin_dashboard
}

function admin_logout {
    CURRENT_ADMIN=""
    echo -e "\n${GREEN}Admin logged out successfully!${NC}"
    loading_animation
    main_menu
}

# --- Student Registration ---
function student_registration {
    show_header
    echo -e "${GREEN}┌──────────────────────────────────────────────┐"
    echo -e "│             STUDENT REGISTRATION             │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Full Name: ${NC}"
    read full_name
   
    echo -e "${CYAN}Student ID: ${NC}"
    read student_id
   
    # Check if student ID already exists
    if grep -q "|$student_id|" "$STUDENT_DB"; then
        echo -e "${RED}Student ID already exists!${NC}"
        press_enter
        main_menu
        return
    fi
   
    echo -e "${CYAN}Username: ${NC}"
    read username
   
    # Check if username already exists
    if grep -q "^$username|" "$STUDENT_DB"; then
        echo -e "${RED}Username already exists!${NC}"
        press_enter
        main_menu
        return
    fi
   
    echo -e "${CYAN}Level: ${NC}"
    read level
   
    echo -e "${CYAN}Term: ${NC}"
    read term
   
    echo -e "${CYAN}Email: ${NC}"
    read email
   
    if ! validate_email "$email"; then
        echo -e "${RED}Invalid email format!${NC}"
        press_enter
        main_menu
        return
    fi
   
    echo -e "${CYAN}Phone Number: ${NC}"
    read phone
   
    if ! validate_phone "$phone"; then
        echo -e "${RED}Invalid phone number format!${NC}"
        press_enter
        main_menu
        return
    fi
   
    echo -e "${CYAN}Gender (M/F/Other): ${NC}"
    read sex
   
    echo -e "${CYAN}Password: ${NC}"
    read -s password
    echo
   
    echo -e "${CYAN}Confirm Password: ${NC}"
    read -s confirm_password
    echo
   
    if [[ "$password" != "$confirm_password" ]]; then
        echo -e "${RED}Passwords don't match!${NC}"
        press_enter
        main_menu
        return
    fi
   
    # Save student data
    echo "$username|$student_id|$full_name|$level|$term|$email|$phone|$sex|$password" >> "$STUDENT_DB"
   
    echo -e "\n${GREEN}Registration successful!${NC}"
    echo -e "${YELLOW}Please remember your login credentials:${NC}"
    echo -e "${CYAN}Username: $username${NC}"
    echo -e "${CYAN}Student ID: $student_id${NC}"
   
    press_enter
    main_menu
}


function student_login {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│                STUDENT LOGIN                 │"
    echo -e "└──────────────────────────────────────────────┘${NC}"

    echo -e "\n${CYAN}Username/Student ID/Email: ${NC}"
    read login_id
    echo -e "${CYAN}Password: ${NC}"
    read -s password
    echo

    # Initialize user_record as empty
    local user_record=""

    # Read the STUDENT_DB line by line and check for match
    while IFS='|' read -r username student_id full_name level term email phone sex stored_password; do
        if { [[ "$username" == "$login_id" ]] || [[ "$student_id" == "$login_id" ]] || [[ "$email" == "$login_id" ]]; } && [[ "$stored_password" == "$password" ]]; then
            user_record="$username|$student_id|$full_name|$level|$term|$email|$phone|$sex|$stored_password"
            CURRENT_USER="$username"
            break
        fi
    done < "$STUDENT_DB"

    if [[ -n "$user_record" ]]; then
        echo -e "${GREEN}Login successful!${NC}"
        loading_animation
        student_dashboard
    else
        echo -e "${RED}Invalid credentials!${NC}"
        press_enter
        main_menu
    fi
}


# --- Student Dashboard ---
function student_dashboard {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│              STUDENT DASHBOARD               │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│  Welcome, ${CURRENT_USER}!                              │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "${WHITE}┌──────────────────────────────────────────────┐"
    echo -e "│  ${CYAN}1.${WHITE} Take Exam                                │"
    echo -e "│  ${CYAN}2.${WHITE} View Available Exams                     │"
    echo -e "│  ${CYAN}3.${WHITE} View My Results                          │"
    echo -e "│  ${CYAN}4.${WHITE} View Profile                             │"
    echo -e "│  ${CYAN}5.${WHITE} Change Password                          │"
    echo -e "│  ${CYAN}6.${WHITE} Logout                                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${YELLOW}Enter your choice: ${NC}"
    read choice
   
    case "$choice" in
        1) take_exam ;;
        2) view_available_exams ;;
        3) view_my_results ;;
        4) view_student_profile ;;
        5) change_student_password ;;
        6) student_logout ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1; student_dashboard ;;
    esac
}
take_exam() {
    show_header
    echo -e "${GREEN}┌──────────────────────────────────────────────┐"
    echo -e "│                  TAKE EXAM                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ ! -s "$EXAM_DB" ]]; then
        echo -e "\n${RED}No exams available!${NC}"
        press_enter
        student_dashboard
        return
    fi

    echo -e "\n${CYAN}Available Exams:${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════════════════════${NC}"

    # Print all available exams and check if they have questions
    while IFS='|' read -r id name subject duration total_marks passing_marks num_questions; do
        # Check if this exam has questions
        local questions_available=$(grep "^$id|" "$QUESTIONS_DB" | wc -l)
       
        echo -e "${WHITE}ID: $id${NC}"
        echo -e "${WHITE}  Name: $name${NC}"
        echo -e "${WHITE}  Subject: $subject${NC}"
        echo -e "${WHITE}  Duration: ${duration} min${NC}"
        echo -e "${WHITE}  Total Marks: $total_marks, Pass Mark: $passing_marks, Questions: $num_questions${NC}"
       
        if [[ $questions_available -gt 0 ]]; then
            echo -e "${GREEN}  ✅ Status: Questions Available ($questions_available questions)${NC}"
        else
            echo -e "${RED}  ❌ Status: No Questions Available${NC}"
        fi
        echo -e "${WHITE}──────────────────────────────────────────────────────────────────────────────${NC}"
    done < "$EXAM_DB"
   
    echo -e "\n${YELLOW}Enter Exam ID to take: ${NC}"
    read exam_id

    if grep -q "^$exam_id|" "$EXAM_DB"; then
        # Check if this exam has questions before proceeding
        local questions_available=$(grep "^$exam_id|" "$QUESTIONS_DB" | wc -l)
        if [[ $questions_available -eq 0 ]]; then
            echo -e "${RED}❌ This exam has no questions available! Please contact the administrator.${NC}"
            press_enter
            student_dashboard
            return
        fi
        conduct_exam "$exam_id"
    else
        echo -e "${RED}Invalid Exam ID!${NC}"
        press_enter
        student_dashboard
    fi
}

function conduct_exam {
    local exam_id="$1"
    local exam_info=$(grep "^$exam_id|" "$EXAM_DB")
    local exam_name=$(echo "$exam_info" | cut -d'|' -f2)
    local subject=$(echo "$exam_info" | cut -d'|' -f3)
    local duration=$(echo "$exam_info" | cut -d'|' -f4)
    local total_marks=$(echo "$exam_info" | cut -d'|' -f5)
    local passing_marks=$(echo "$exam_info" | cut -d'|' -f6)
    local num_questions=$(echo "$exam_info" | cut -d'|' -f7)

    # Check if questions exist for this exam
    local questions_count=$(grep "^$exam_id|" "$QUESTIONS_DB" | wc -l)
    if [[ $questions_count -eq 0 ]]; then
        echo -e "${RED}No questions found for this exam!${NC}"
        press_enter
        student_dashboard
        return
    fi

    show_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│              EXAM IN PROGRESS                │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Exam: $exam_name${NC}"
    echo -e "${CYAN}Subject: $subject${NC}"
    echo -e "${CYAN}Duration: ${duration} minutes${NC}"
    echo -e "${CYAN}Total Marks: $total_marks${NC}"
    echo -e "${CYAN}Passing Marks: $passing_marks${NC}"
    echo -e "${CYAN}Total Questions: $questions_count${NC}"
   
    echo -e "\n${YELLOW}Press Enter to start the exam...${NC}"
    read -r < /dev/tty

    # Timer initialization
    local start_time=$(date +%s)
    local end_time=$((start_time + duration * 60))
    local score=0
    local question_counter=0

    # Prepare answer file for this attempt
    mkdir -p student_answers
    local answer_file="student_answers/${CURRENT_USER}_${exam_id}.txt"
    > "$answer_file"  # Clear previous answers if any

    # Read questions from database for this exam ID
    while IFS='|' read -r exam_id_db question_num question opt_a opt_b opt_c opt_d correct_answer marks; do
        ((question_counter++))
        current_time=$(date +%s)
        if (( current_time >= end_time )); then
            echo -e "\n${RED}Time's up! Exam auto-submitted.${NC}"
            sleep 2
            break
        fi
        remaining=$(( (end_time - current_time) / 60 ))
        if (( remaining < 0 )); then remaining=0; fi
        
        clear
        show_header
        echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
        echo -e "│              EXAM IN PROGRESS                │"
        echo -e "└──────────────────────────────────────────────┘${NC}"
        echo -e "${CYAN}Time remaining: $remaining minute(s)${NC}"
        echo -e "${CYAN}Question $question_num/$num_questions${NC}"
        echo -e "${CYAN}Marks: $marks${NC}"
        echo -e "\n${WHITE}$question${NC}"
        echo -e "\n${CYAN}A) $opt_a${NC}"
        echo -e "${CYAN}B) $opt_b${NC}"
        echo -e "${CYAN}C) $opt_c${NC}"
        echo -e "${CYAN}D) $opt_d${NC}"

        echo -e "\n${YELLOW}Your answer (A/B/C/D): ${NC}"
        read -r -p "" -e answer < /dev/tty

        if [[ -z "$answer" ]]; then
            answer="X"  # Default invalid answer if empty
        fi
        answer_upper=$(echo "$answer" | tr '[:lower:]' '[:upper:]')
        if [[ "$answer_upper" != "A" && "$answer_upper" != "B" && "$answer_upper" != "C" && "$answer_upper" != "D" ]]; then
            answer_upper="X"
        fi

        # Save answer for review
        echo "$question_num|$answer_upper|$correct_answer|$question|$opt_a|$opt_b|$opt_c|$opt_d" >> "$answer_file"

        # Feedback
        if [[ "$answer_upper" == "$correct_answer" ]]; then
            echo -e "${GREEN}Correct!${NC}"
            score=$((score + marks))
        else
            # Show both answers
            declare -A options=( ["A"]="$opt_a" ["B"]="$opt_b" ["C"]="$opt_c" ["D"]="$opt_d" )
            echo -e "${RED}Wrong! Your answer: $answer_upper) ${options[$answer_upper]:-No answer}. The correct answer was: $correct_answer) ${options[$correct_answer]}.${NC}"
        fi

        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read -r < /dev/tty

    done < <(grep "^$exam_id|" "$QUESTIONS_DB" | sort -t'|' -k2n)

    local end_time_actual=$(date +%s)
    local seconds_taken=$((end_time_actual - start_time))
    local minutes_taken=$((seconds_taken / 60))
    local seconds_remain=$((seconds_taken % 60))

    # Determine pass/fail
    local status="FAILED"
    if [[ $score -ge $passing_marks ]]; then
        status="PASSED"
    fi

    # Save result
    local current_date=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$CURRENT_USER|$exam_id|$score|$total_marks|$status|$current_date" >> "$RESULTS_DB"

    # Show result
    clear
    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│                 EXAM RESULT                  │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Exam: $exam_name${NC}"
    echo -e "${CYAN}Your Score: $score/$total_marks${NC}"
    echo -e "${CYAN}Time Taken: $minutes_taken minutes $seconds_remain seconds${NC}"
    echo -e "${CYAN}Percentage: $(( (score * 100) / total_marks ))%${NC}"

    if [[ "$status" == "PASSED" ]]; then
        echo -e "\n${GREEN}🎉 CONGRATULATIONS! YOU PASSED! 🎉${NC}"
    else
        echo -e "\n${RED}❌ SORRY! YOU FAILED. BETTER LUCK NEXT TIME! ❌${NC}"
    fi

    press_enter
    student_dashboard
}
function view_available_exams {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│              AVAILABLE EXAMS                 │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ -s "$EXAM_DB" ]]; then
        echo -e "\n${CYAN}Available Exams:${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
       
        while IFS='|' read -r id name subject duration total_marks passing_marks num_questions; do
            echo -e "${WHITE}📚 Exam ID: ${CYAN}$id${NC}"
            echo -e "${WHITE}📖 Name: ${CYAN}$name${NC}"
            echo -e "${WHITE}📋 Subject: ${CYAN}$subject${NC}"
            echo -e "${WHITE}⏰ Duration: ${CYAN}${duration} minutes${NC}"
            echo -e "${WHITE}📊 Total Marks: ${CYAN}$total_marks${NC}"
            echo -e "${WHITE}✅ Passing Marks: ${CYAN}$passing_marks${NC}"
            echo -e "${WHITE}❓ Questions: ${CYAN}$num_questions${NC}"
            echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
        done < "$EXAM_DB"
    else
        echo -e "\n${RED}No exams available!${NC}"
    fi
   
    press_enter
    student_dashboard
}

function view_my_results {
    show_header
    echo -e "${GREEN}┌──────────────────────────────────────────────┐"
    echo -e "│                 MY RESULTS                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    if [[ -s "$RESULTS_DB" ]]; then
        local my_results=$(grep "^$CURRENT_USER|" "$RESULTS_DB")
       
        if [[ -n "$my_results" ]]; then
            local total_attempts=0
            local passed_count=0
            local failed_count=0
            local total_score=0
            local max_score=0
           
            echo -e "\n${CYAN}Your Exam History:${NC}"
            echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
            echo -e "${WHITE}Exam ID\t\tScore\t\tStatus\t\tDate & Time${NC}"
            echo -e "${CYAN}───────────────────────────────────────────────────────────────${NC}"
           
            while IFS='|' read -r student exam_id score total_marks status date_time; do
                echo -e "${WHITE}$exam_id\t$score/$total_marks\t\t$status\t\t$date_time${NC}"
                ((total_attempts++))
                total_score=$((total_score + score))
                if [[ $score -gt $max_score ]]; then
                    max_score=$score
                fi
                if [[ "$status" == "PASSED" ]]; then
                    ((passed_count++))
                else
                    ((failed_count++))
                fi
            done <<< "$my_results"
           
            echo -e "\n${CYAN}📊 Your Statistics:${NC}"
            echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
            echo -e "${GREEN}🎯 Total Attempts: $total_attempts${NC}"
            echo -e "${GREEN}✅ Passed: $passed_count${NC}"
            echo -e "${RED}❌ Failed: $failed_count${NC}"
            echo -e "${YELLOW}🏆 Highest Score: $max_score${NC}"
           
            if [[ $total_attempts -gt 0 ]]; then
                local avg_score=$((total_score / total_attempts))
                local success_rate=$((passed_count * 100 / total_attempts))
                echo -e "${YELLOW}📈 Average Score: $avg_score${NC}"
                echo -e "${YELLOW}🎖  Success Rate: $success_rate%${NC}"
            fi

            # --- Show wrong answers for a selected exam ---
            echo -e "\n${YELLOW}Enter Exam ID to view your wrong answers (or press Enter to skip): ${NC}"
            read selected_exam_id
            if [[ -n "$selected_exam_id" ]]; then
                local answer_file="student_answers/${CURRENT_USER}_${selected_exam_id}.txt"
                if [[ ! -f "$answer_file" ]]; then
                    echo -e "${RED}No detailed answers found for exam ID $selected_exam_id.${NC}"
                else
                    echo -e "\n${CYAN}Your Wrong Answers for Exam ID: $selected_exam_id${NC}"
                    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
                    while IFS='|' read -r qnum student_ans correct_ans question opt_a opt_b opt_c opt_d; do
                        if [[ "$student_ans" != "$correct_ans" ]]; then
                            declare -A options=( ["A"]="$opt_a" ["B"]="$opt_b" ["C"]="$opt_c" ["D"]="$opt_d" )
                            echo -e "${RED}Question $qnum:${NC} $question"
                            echo -e "${RED}Your answer: $student_ans) ${options[$student_ans]:-No answer}${NC}"
                            echo -e "${GREEN}Correct answer: $correct_ans) ${options[$correct_ans]}${NC}\n"
                        fi
                    done < "$answer_file"
                fi
            fi
            # ---------------------------------------------------------
        else
            echo -e "\n${RED}You haven't taken any exams yet!${NC}"
        fi
    else
        echo -e "\n${RED}No results found!${NC}"
    fi
   
    press_enter
    student_dashboard
}

function view_student_profile {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│                 MY PROFILE                   │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    local student_info=$(grep "^$CURRENT_USER|" "$STUDENT_DB")
   
    if [[ -n "$student_info" ]]; then
        IFS='|' read -r username student_id full_name level term email phone sex password <<< "$student_info"
       
        echo -e "\n${CYAN}Personal Information:${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}👤 Full Name: ${CYAN}$full_name${NC}"
        echo -e "${WHITE}🆔 Student ID: ${CYAN}$student_id${NC}"
        echo -e "${WHITE}👨‍💻 Username: ${CYAN}$username${NC}"
        echo -e "${WHITE}🎓 Level: ${CYAN}$level${NC}"
        echo -e "${WHITE}📚 Term: ${CYAN}$term${NC}"
        echo -e "${WHITE}📧 Email: ${CYAN}$email${NC}"
        echo -e "${WHITE}📱 Phone: ${CYAN}$phone${NC}"
        echo -e "${WHITE}⚧  Gender: ${CYAN}$sex${NC}"
       
        # Show exam statistics
        if [[ -s "$RESULTS_DB" ]]; then
            local my_results=$(grep "^$CURRENT_USER|" "$RESULTS_DB")
            if [[ -n "$my_results" ]]; then
                local exam_count=$(echo "$my_results" | wc -l)
                local passed=$(echo "$my_results" | grep "PASSED" | wc -l)
               
                echo -e "\n${CYAN}Academic Performance:${NC}"
                echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
                echo -e "${WHITE}📊 Total Exams Taken: ${CYAN}$exam_count${NC}"
                echo -e "${WHITE}✅ Exams Passed: ${CYAN}$passed${NC}"
                echo -e "${WHITE}❌ Exams Failed: ${CYAN}$((exam_count - passed))${NC}"
               
                if [[ $exam_count -gt 0 ]]; then
                    local success_rate=$((passed * 100 / exam_count))
                    echo -e "${WHITE}🎯 Success Rate: ${CYAN}$success_rate%${NC}"
                fi
            fi
        fi
    else
        echo -e "\n${RED}Profile not found!${NC}"
    fi
   
    press_enter
    student_dashboard
}

function change_student_password {
    show_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│              CHANGE PASSWORD                 │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Current Password: ${NC}"
    read -s current_pass
    echo -e "${CYAN}New Password: ${NC}"
    read -s new_pass
    echo -e "${CYAN}Confirm New Password: ${NC}"
    read -s confirm_pass
    echo
   
    if grep -q "^$CURRENT_USER|.*|$current_pass$" "$STUDENT_DB"; then
        if [[ "$new_pass" == "$confirm_pass" ]]; then
            sed -i "s/^$CURRENT_USER|\(.*\)|$current_pass$/$CURRENT_USER|\1|$new_pass/" "$STUDENT_DB"
            echo -e "\n${GREEN}✅ Password changed successfully!${NC}"
        else
            echo -e "\n${RED}❌ New passwords don't match!${NC}"
        fi
    else
        echo -e "\n${RED}❌ Current password is incorrect!${NC}"
    fi
   
    press_enter
    student_dashboard
}

function student_logout {
    CURRENT_USER=""
    echo -e "\n${GREEN}👋 Logged out successfully!${NC}"
    loading_animation
    main_menu
}

# --- Student Profile (Guest Access) ---
function student_profile {
    show_header
    echo -e "${BLUE}┌──────────────────────────────────────────────┐"
    echo -e "│            STUDENT PROFILE ACCESS           │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Enter Student ID to view profile: ${NC}"
    read student_id
   
    local student_info=$(grep "|$student_id|" "$STUDENT_DB")
   
    if [[ -n "$student_info" ]]; then
        IFS='|' read -r username sid full_name level term email phone sex password <<< "$student_info"
       
        echo -e "\n${CYAN}Student Profile:${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}👤 Full Name: ${CYAN}$full_name${NC}"
        echo -e "${WHITE}🆔 Student ID: ${CYAN}$sid${NC}"
        echo -e "${WHITE}👨‍💻 Username: ${CYAN}$username${NC}"
        echo -e "${WHITE}🎓 Level: ${CYAN}$level${NC}"
        echo -e "${WHITE}📚 Term: ${CYAN}$term${NC}"
        echo -e "${WHITE}📧 Email: ${CYAN}$email${NC}"
        echo -e "${WHITE}📱 Phone: ${CYAN}$phone${NC}"
        echo -e "${WHITE}⚧  Gender: ${CYAN}$sex${NC}"
    else
        echo -e "\n${RED}❌ Student not found!${NC}"
    fi
   
    press_enter
    main_menu
}

# --- Forgot Password ---
function forgot_password {
    show_header
    echo -e "${YELLOW}┌──────────────────────────────────────────────┐"
    echo -e "│              FORGOT PASSWORD                 │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
   
    echo -e "\n${CYAN}Enter your Student ID: ${NC}"
    read student_id
    echo -e "${CYAN}Enter your Email: ${NC}"
    read email
   
    local student_info=$(grep "|$student_id|.*|$email|" "$STUDENT_DB")
   
    if [[ -n "$student_info" ]]; then
        echo -e "\n${GREEN}✅ Student verified!${NC}"
        echo -e "${CYAN}Enter new password: ${NC}"
        read -s new_pass
        echo -e "${CYAN}Confirm new password: ${NC}"
        read -s confirm_pass
        echo
       
        if [[ "$new_pass" == "$confirm_pass" ]]; then
            # Update password
            local username=$(echo "$student_info" | cut -d'|' -f1)
            sed -i "s/^$username|\(.\)|.$/$username|\1|$new_pass/" "$STUDENT_DB"
            echo -e "\n${GREEN}🎉 Password reset successfully!${NC}"
        else
            echo -e "\n${RED}❌ Passwords don't match!${NC}"
        fi
    else
        echo -e "\n${RED}❌ Student ID and Email don't match!${NC}"
    fi
   
    press_enter
    main_menu
}

# --- Exit System ---
function exit_system {
    show_header
    echo -e "${PURPLE}┌──────────────────────────────────────────────┐"
    echo -e "│            THANK YOU FOR USING               │"
    echo -e "│          QUICKQUIZ EXAM SYSTEM               │"
    echo -e "└──────────────────────────────────────────────┘${NC}"
    echo -e "\n${CYAN}🎓 Good luck with your studies! 📚${NC}"
    echo -e "${YELLOW}👋 Goodbye!${NC}\n"
    exit 0
}

# --- Start Application ---
main_menu
