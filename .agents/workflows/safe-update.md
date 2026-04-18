---
description: How to safely update the repository from the official upstream without messing up local changes
---

This workflow details how to pull down the latest commits from the official Open Notebook repository (`origin/main`) while preserving any uncommitted local changes and safely resolving divergent branches.

### Steps to safely update

1. **Stash uncommitted changes:** 
   This safely tucks away any work you are currently doing so it doesn’t get mangled during the merge process.
   ```powershell
   git stash
   ```

2. **Fetch the latest upstream data:**
   ```powershell
   git fetch origin
   ```

3. **Perform a safe test merge (Highly recommended):**
   Create a temporary branch to test the merge. This confirms there are no hidden conflicts between upstream changes and any custom local commits you made.
   ```powershell
   git checkout -b temp-test-merge
   git merge origin/main
   ```
   *If the merge has horrific conflicts, you can simply abort (`git merge --abort`), `git checkout main`, and delete the test branch. Your `main` branch remains untouched!*

4. **Apply the successful merge:**
   If the test merge succeeded smoothly, switch back to `main` and fast-forward the branch.
   ```powershell
   git checkout main
   git merge temp-test-merge
   ```

5. **Clean up the test branch:**
   Remove the temporary branch since the merge is complete.
   ```powershell
   git branch -d temp-test-merge
   ```

6. **Restore your uncommitted changes:**
   Pop the uncommitted work you stashed in Step 1 back into your working directory.
   ```powershell
   git stash pop
   ```
   *Note: If popping the stash results in any conflicts within your working files, you can resolve them manually in your editor as usual.*
