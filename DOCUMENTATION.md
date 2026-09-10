# Git & GitHub DevOps Assignment Documentation

**Student Name**: Shubhajit Paul  
**Course**: DevOps Masterclass | TuteDude  
**GitHub Repository Link**: https://github.com/shubhajit-paul006/Tutedude.git  
**Submission Date**: September 2026  

---

## 1. Executive Summary
This assignment demonstrates the comprehensive end-to-end Git and GitHub workflows utilized in modern DevOps pipelines, including:
1. Repository Setup & Branching Strategy (SSHGit setup, initial commits, branch merges).
2. Merge Conflict Resolution (Divergent edits in JSON backend data and manual resolution).
3. Parallel Feature Development (Decoupled frontend form development on master_1 and backend API endpoints on master_2).
4. Sequential Commits, Soft Reset, and Non-Destructive Rebasing (Granular single-purpose commits, git reset --soft, and git rebase preserving complete commit history).

---

## 2. Task 1: Repository Setup & First Branch
1. Initialized repository and linked to https://github.com/shubhajit-paul006/Tutedude.git.
2. Created branch showhajit-paul006.
3. Added Flask & MongoDB project source files, committed and merged into main.
---

## 3. Task 2: Update JSON & Resolve Conflicts
1. Created branch shubhajit-paul006_new.
2. Updated data/data.json with enriched course data.
3. Created divergent change in main to trigger conflict.
4. Merged shubhajit-paul006_new into main, detected conflict and resolved by accepting changes from _new branch.
5. Committed resolution.
---

## 4. Task 3: Parallel Feature Development
1. Branched master_1 and master_2 from main.
2. master_1: Created To-Do page (form with Item Name and Item Description).
3. master_2: Created backend POST /submittodoitem route inserting into MongoDB.
4. Merged both features into main cleanly.
---

## 5. Task 4: Sequential Commits, Reset & Rebase
1. Enhanced master_1 To-Do form with 3 sequential commits:
   - Commit 1: Add Item ID
   - Commit 2: Add Item UUID
   - Commit 3: Add Item Hash
2. Merged master_1 into main.
3. In main, performed git reset --soft back to Item ID commit, committed baseline.
4. Rebased master_1 onto main with git rebase main master_1 preserving individual commits.
---

## 6. Git Log Graph Verification
```text
* aeeb837 Enhance To-Do form (master_1): Add Item Hash field
* 2d7f9e5 Enhance To-Do form (master_1): Add Item UUID field
* 8993836 Consolidate reset state on main with Item ID baseline
* f3669ee Enhance To-Do form (master_1): Add Item ID field
* 19f549e Feature (master_1): Add To-Do frontend page with Item Name and Item Description form
| * a4ed11e Backend API (master_2): Add /submittodoitem POST route storing itemName and itemDescription into MongoDB
|/  
*   ca97a30 Resolve merge conflict: Accept changes from shubhajit-paul006_new branch
|\p  
| * 237b1bd Update API JSON data with enriched course curriculum in _new branch
* | 0030525 Mainline modification to API JSON data
|/  
* a2£ee7e Initial commit: Add Flask & MongoDB project source files

```

---

## 7. Remote GitHub Repository
All branches synchronized to: https://github.com/shubhajit-paul006/Tutedude.git
- main
- shubhajit-paul006
- shubhajit-paul006_new
- master_1
- master_2
