# 🖥️ Linux System Quiz game (Bash)

A beginner → intermediate Linux scripting project that generates brain jotting questions directly in the terminal using Bash and standard Linux CLI tools.
The script provides a quick overview of system health, usage statistics, and running processes in a clean and formatted output.

---

## 🎯 Project Goals

This project aims to:

Practice Bash scripting fundamentals
Use Linux command-line tools to collect system data
Display formatted system statistics in the terminal
Build a small but real DevOps-style utility script

---

## The script prints random multiple chois questions

System identity, Uptime, Memory usage, Disk usage, Running processes, CPU usage, Warning  messages when resources are low

---

## 🛠 Tech Stack

**Language**
-Bash (Shell scripting)

**Linux command-line tools Used**
-whoami
-hostname
-date
-uptime
-free
-df
-ps
-grep
-awk
-head
-top

**Other Tools**
-Git & GitHub

---

## 🖥 Features

-Displays system identity (user, hostname, date)
-Shows system uptime in human-readable format
-Displays memory usage (Total / Used / Free)
-Displays disk usage for root partition
-Counts total running processes
-Shows Top 5 memory-consuming processes
-Displays real-time CPU usage
-Color-coded terminal output (green / red warnings)
-Warning alerts when Free memory is low  and Disk space is lowmais le lien il faut arranger je ne comprend pas
-Clean and structured terminal dashboard

---

## 📷 Example Output

![System Information ]
<img width="1920" height="1080" alt="Screenshot from 2026-04-09 16-14-13" src="https://github.com/user-attachments/assets/565b1800-0384-4261-b912-b2faba419f8d" />

---

## ⚙ Installation & Setup

    ```Clone the repository:

git clone <git@github.com:Hache-premier/Quiz-game.git>
cd system_info_dashbord

Give execution permission to the script:

chmod +x sysinfo.sh

Run the script:

./sysinfo.sh

---

## 📁 Project Structure

system_info_dashboard/
├── assets/
│   └── images/
│       ├── systeminfoexample.png
├── quiz.sh
└── README.md

🧠 Challenges Faced
Parsing command output using awk and grep
Formatting terminal output cleanly
Extracting numeric values for comparisons
Implementing color-coded warnings in Bash
Calculating CPU usage from top command output

📚 What I Learned
Writing structured Bash scripts
Using command substitution $(...)
Working with Linux system monitoring commands
Parsing CLI output with awk
Creating readable terminal dashboards
Adding logic and conditional warnings in Bash

🚀 Future Improvements
Add command-line flags:
--compact
--verbose
Save output to a log file
Add system temperature monitoring
Add network usage statistics
Convert into a cron job for periodic monitoring

👨🏽‍💻 Author
Ndonwi Ashley Cheo
Junior Developer
📩 Email: <ac89123@gmail.com>
🌍 Based in Cameroon | Open to remote opportunities
