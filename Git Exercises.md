# Git Exercises
## Master
run `git push`
## Commit one file
run
```
git add A.txt
git commit -m "Add A.txt"
git push
```
## Commit one file of two currently staged
run
```
git reset
git add A.txt
git commit -m "Add A.txt"
git push
```
## Ignore unwanted files
set the contents of .gitignore to
```
*.exe
*.o
*.jar
libraries/
```
then run
```
git add .
git commit -m "<message>"
git push
```
## Chase branch that escaped
run
```
git merge escaped
git push
```
## Resolve a merge conflict
run
```
git merge another-piece-of-work
```
edit equations.txt to
```
2 + 3 = 5
```
then run
```
git commit -am "<message>"
git push
```
## Saving your work
run
```
git stash
```
then fix the bug and run
```
git commit -am "<message>"
git stash pop
```
then finish the code and then run
```
git commit -am "<message>"
git push
```
## Change branch history
run
```
git rebase hot-bugfix
git push
```
## Remove ignored file
run
```
git commit -am "<message>"
git rm ignored.txt
git push
```
## Change a letter case in the filename of an already tracked file
run
```
git mv File.txt file.txt
git commit -am "<message>"
git push
```
## Fix typographic mistake in the last commit
fix the typo then run
```
git commit -a --amend
```
fix the typo in the commit message then run
```
git push
```
## Forge the commit's date
run
```
GIT_COMMITTER_DATE="1987-01-01 00:00:00" git commit --amend --no-edit --date "1987-01-01 00:00:00"
git push
```
GIT_COMMITTER_DATE="1987-01-01 00:00:00" git commit --amend --date "1987-01-01 00:00:00"
## Fix typographic mistake in old commit
```
git rebase -i HEAD~2
```
change both pick to edit
fix the typo and then run
```
git commit -a -ammend
```
fix the typo in the commit message and then run
```
git rebase --continue
```
fix the typo again and run
```
git commit -a
git push
```

