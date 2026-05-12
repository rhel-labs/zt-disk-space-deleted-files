# Troubleshooting Tools - zt-disk-space-deleted-files Lab

## Lab Overview
This lab teaches troubleshooting deleted files that are still consuming disk space because a process has them open.

## Key Concept
Understanding Linux file handling: when a file is deleted but still open by a process, the space isn't freed until the process closes the file handle or terminates.

---

## Tools Used & Their Application

### 1. **df** - Disk Filesystem Usage
**Purpose:** Identify disk space problems and verify changes

**Usage in Lab:**
- Module 02: Initial verification of disk space problem
  ```bash
  df -h /
  ```
- Module 02 & 05: Before and after comparison to see if space was freed
- **Key Learning:** Shows that deleting a file doesn't always free space immediately

**Slide Points:**
- Shows mounted filesystem usage
- `-h` flag for human-readable output
- Focus on "Use%" column - danger at >90%
- Real-time view of available space

---

### 2. **du** - Disk Usage
**Purpose:** Find which directories and files are consuming space

**Usage in Lab:**
- Module 02: Identify top-level directory consumers
  ```bash
  du -sh /* 2>/dev/null | sort -hr | head -10
  ```
- Module 02: Drill down into /var/log
  ```bash
  du -sh /var/log/* 2>/dev/null | sort -hr
  ```
- Module 02: Find specific large file
  ```bash
  du -sh /var/log/super-business/*
  ```

**Slide Points:**
- `-s` = summary (don't show subdirectories)
- `-h` = human-readable sizes
- Pipe through `sort -hr` to order by size (largest first)
- Use `head` to limit output to top consumers
- `2>/dev/null` suppresses permission errors
- Hierarchical investigation: start broad, drill down

---

### 3. **ls** - List Directory Contents  
**Purpose:** View file details including size, permissions, timestamps

**Usage in Lab:**
- Module 02: See file sizes with details
  ```bash
  ls -lh /var/log/super-business/
  ```
- Module 02: Verify file was deleted
- Module 05: Check directory after cleanup

**Slide Points:**
- `-l` = long format with details
- `-h` = human-readable file sizes
- Shows permissions, owner, size, modification time
- Simple verification tool

---

### 4. **lsof** - List Open Files
**Purpose:** Show which processes have files open (THE KEY TOOL for this lab)

**Usage in Lab:**
- Module 02: Check what process has the file open
  ```bash
  sudo lsof /var/log/super-business/business-monitor.log
  ```
- Module 04: Find all deleted files still consuming space
  ```bash
  lsof | grep deleted
  lsof +L1 /var/log
  ```
- Module 05: Verify cleanup (should show nothing)

**Slide Points:**
- **Critical tool** for deleted-but-open file scenarios
- Shows COMMAND, PID, USER, FD, TYPE, DEVICE, SIZE, NODE, NAME
- `grep deleted` finds files unlinked from filesystem
- `+L1` flag shows files with link count < 1 (deleted files)
- SIZE/OFF column shows space consumed
- **(deleted)** marker at end of filename is the key indicator

---

### 5. **ps** - Process Status
**Purpose:** View running processes and their details

**Usage in Lab:**
- Module 03: Identify the business-monitor process
  ```bash
  ps aux | grep -i business
  ```
- Module 04: Get full process details
  ```bash
  ps -p $BUSINESS_PID -f
  ```

**Slide Points:**
- `ps aux` shows all processes with details
- `-p PID` shows specific process
- `-f` = full format listing
- Confirms what process is holding the file open

---

### 6. **pgrep** - Process Grep
**Purpose:** Find process IDs by name pattern

**Usage in Lab:**
- Module 03: Get PID of business-monitor script
  ```bash
  pgrep -f business-monitor.sh
  ```
- Used to store PID for subsequent commands

**Slide Points:**
- Simpler than `ps aux | grep | awk`
- `-f` matches full command line (not just process name)
- Returns just the PID(s)
- Useful for scripting and automation

---

### 7. **/proc/$PID/fd/** - Process File Descriptors
**Purpose:** Examine what files a specific process has open

**Usage in Lab:**
- Module 03: Investigate process file descriptors directly
  ```bash
  ls -l /proc/$BUSINESS_PID/fd/
  ```
- Shows **(deleted)** marker on unlinked files

**Slide Points:**
- `/proc` is a virtual filesystem with process info
- Each running process has `/proc/$PID/`
- `fd/` subdirectory contains file descriptors
- Symlinks point to open files
- Alternative way to discover deleted-but-open files
- More manual than `lsof` but educational

---

### 8. **systemctl** - Systemd Service Control
**Purpose:** Manage systemd services (restart to close file handles)

**Usage in Lab:**
- Module 05: Check service status
  ```bash
  systemctl status business-monitor.service
  ```
- Module 05: Restart service to close file handles
  ```bash
  systemctl restart business-monitor.service
  ```
- Module 05: Verify service is running after restart

**Slide Points:**
- Modern way to manage services
- `status` shows if service is running and recent logs
- `restart` stops and starts the service (closes all file handles)
- More graceful than killing processes
- Service comes back up cleanly with fresh file handles

---

### 9. **rm** - Remove Files
**Purpose:** Delete files (triggers the mystery when file is still open)

**Usage in Lab:**
- Module 02: Delete the large log file
  ```bash
  sudo rm /var/log/super-business/business-monitor.log
  ```
- **This creates the mystery:** file deleted but space not freed

**Slide Points:**
- Removes directory entry (link) to file
- Space only freed when ALL of these are true:
  - All directory links removed (unlinked)
  - All processes close the file
- If process has file open: file becomes "ghost" - no directory entry but data still on disk
- Common mistake: delete log file while service is running

---

## Troubleshooting Flow

### Discovery Phase
1. **df** → Confirm disk space problem exists
2. **du** → Find large directories (hierarchical search)
3. **ls** → Identify specific large files
4. **lsof** (first use) → Check what process has file open

### The Mystery
5. **rm** → Delete the file (but space not freed!)
6. **df** → Verify space still consumed
7. **ls** → Confirm file is gone from directory

### Investigation Phase
8. **ps / pgrep** → Find the process still running
9. **/proc/$PID/fd/** → See deleted file still open
10. **lsof** (second use) → Confirm deleted-but-open state

### Resolution Phase
11. **systemctl restart** → Close file handles and free space
12. **df** → Verify space reclaimed
13. **lsof** → Verify no more deleted files

---

## Key Teaching Points

### Linux File Behavior
- **Inodes vs Directory Entries:** File data exists until all links AND file handles are gone
- **Reference Counting:** Kernel tracks links + open file descriptors
- **Ghost Files:** Deleted files with open handles exist but are invisible to ls/find

### Best Practices
- Never delete log files while the service is running
- Use log rotation (logrotate) instead of manual deletion
- Or: stop service → delete → start service
- Or: truncate instead of delete: `cat /dev/null > logfile`
- Proactive monitoring to avoid emergencies

### Troubleshooting Methodology
1. Confirm the problem (df)
2. Identify the source (du, ls)
3. Check process context (lsof, ps)
4. Understand the mechanism (/proc, lsof grep deleted)
5. Take corrective action (systemctl restart)
6. Verify resolution (df, lsof)

---

## Slide Deck Suggestions

### Slide 1: The Problem
- Screenshot of `df -h` showing 95% usage
- "Disk space crisis!"

### Slide 2: Finding the Culprit
- `du` command hierarchy
- Visual: tree diagram showing drill-down from / → /var → /var/log → specific file

### Slide 3: The Mystery
- Before: file exists, shown by ls
- Delete with rm
- After: file gone from ls, but df shows same usage!
- "Where did the space go?"

### Slide 4: Understanding File Handles
- Diagram showing:
  - Directory entry (removed by rm)
  - Inode and data blocks (still on disk)
  - Process with open file descriptor (still pointing to inode)

### Slide 5: lsof - The Key Tool
- `lsof | grep deleted` output
- Highlight the "(deleted)" marker
- Show SIZE/OFF column indicating space consumed

### Slide 6: /proc Filesystem
- `/proc/$PID/fd/` listing
- Symlinks showing deleted files
- Alternative investigation path

### Slide 7: The Fix
- `systemctl restart` closes handles
- `df` shows space reclaimed
- Before/after comparison

### Slide 8: Best Practices
- Log rotation strategies
- Monitoring setup
- Prevention vs. emergency response

### Slide 9: Tool Summary Table
| Tool | Purpose | Key Flag |
|------|---------|----------|
| df   | Disk space | -h |
| du   | Directory usage | -sh |
| ls   | File details | -lh |
| lsof | Open files | grep deleted, +L1 |
| ps   | Process info | aux, -p PID |
| /proc | Process internals | /proc/$PID/fd/ |
| systemctl | Service control | restart, status |

---

## Demo Script Notes

1. Start with full disk (setup script)
2. Show df problem
3. Use du to find large directory
4. ls to find specific file
5. lsof to see it's open
6. Delete with rm
7. df shows space still consumed (audience surprise!)
8. Show /proc/$PID/fd/ with deleted marker
9. lsof grep deleted
10. systemctl restart
11. df shows space freed
12. lsof shows cleanup complete
