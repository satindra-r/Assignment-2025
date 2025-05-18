# Over The Wire
## Level 0
run
```
ssh bandit.labs.overthewire.org -l bandit0 -p 2220
```
and enter the password
## Level 1
run
```
cat readme
```
## Level 2
run
```
cat ./-
```
## Level 3
run
```
cat "spaces in this filename"
```
## Level 4
run
```
cd inhere
la
cat ...Hiding-From-You
```
## Level 5
run
```
cd inhere
```
find the file such that `file ./<filename>` returns ASCII
## Level 5
run
```
find -size 1033c -exec cat {} \;
```
## Level 6
run
```
find -user bandit7 -group bandit6 -size 33c 2>/dev/null -exec cat {} \;
```
## Level 7
run
```
cat data.txt | grep "millionth"
```
## Level 8
run
```
sort data.txt | uniq -u
```
## Level 9
run
```
cat data.txt | grep -E "=+ \w+$" -h -a
```
## Level 10
run
```
cat data.txt | base64 --decode
```
## Level 11
run
```
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
```
## Level 12
run
```
file data
```
then depending upon type
```
mv data data.gz
gzip -d data.gz
```
```
bzip2 -d data
```
```
tar -xf data
```
and rename the resulting file to data until file type is ascii
## Level 13
run
```
find -exec cat {} \;
```
## Level 14
run
```
ssh -i <path/to/key> bandit.labs.overthewire.org -l bandit0 -p 2220
```
## Level 15
run
```
cat /etc/bandit_pass/bandit14
nc localhost 30000
```
and enter the password
## Level 16
run
```
openssl s_client -connect localhost:30001
```
and enter the password
## Level 17
run
```
nmap -p31000-32000 localhost
```
then test each connection and send the password with the -quiet flag
## Level 18
run
```
diff passwords.new passwords.old
```
the password is the first string of characters
## Level 19
run
```
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
```
## Level 20
run
```
./bandit20-do cat /etc/bandit_pass/bandit20
```
