--- LIBRARY database


select * from book
select * from book_authors
select * from book_copies
select * from book_loans
select * from borrower
select * from library_branch

--1) Write a query to count the number of ‘S’ in the word ‘MICROSOFT SQL SERVER SERVICES SESSION’.

declare @str varchar(50)
set @str = 'MICROSOFT SQL SERVER SERVICES SESSION'
select len(@str)-len(replace(@str,'S',''))

--2) How many copies of the book titled ‘The Lost Tribe’ are owned by the library branch whose name is "sharpstown"?

select No_Of_copies from book_copies b join library_branch l on b.BranchId = l.BranchId
where branchName = 'Sharpstown' and Bookid in (select BookId from book where Title = 'The Lost Tribe')

--3)How many copies of the book titled ‘The Lost Tribe’ are owned by each library branch?

select branchName, No_Of_copies from library_branch l
join book_copies b
on l.BranchId = b.BranchId
join book bk
on b.BookId = bk.BookId
where bk.Title = 'The Lost Tribe'

--4)Retrieve the names of all borrowers who do not have any books checked out.

select * from book_loans
select * from borrower

select cardNO,Name from(
select bw.CardNO,bw.Name,
case
when bl.DueDate>=bl.DateOut and bl.DueDate is not null then 'Book Check Out'
else 'Book Not Check Out'
end as 'Co'
from borrower bw 
left join book_loans bl
on bw.CardNo = bl.CardNo)as a where Co = 'Book Not Check Out'

--5)For each book that is loaned out from the "Sharpstown" branch, retrieve the book title, borrower's name, borrower's address , borrower's Phone format as 
--(xxx-xxx-xxxx), Due date Format the date as (March-10-2010) and Count of days between the Dateout and Duedate as ‘No of Days For Due date’

select * from book
select * from book_authors
select * from book_copies
select * from book_loans
select * from borrower
select * from library_branch

select b.Title as 'Book Title',
bo.Name as 'Borrower Name',
bo.Address as 'Borrower Address',
format(cast(bo.Phone as Bigint),'###-###-####') as 'Borrowers Phone',
convert(varchar,bl.DueDate,7) as 'Due Date',
datediff(d,bl.DueDate,bl.DateOut) as 'No of Days'
from book b
left join book_loans bl
on b.BookId = bl.BookId
left join borrower bo
on bl.CardNo = bo.CardNo
left join library_branch lb
on bl.BranchId = lb.BranchId 
where lb.BranchName = 'Sharpstown'

--6)For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select * from book_loans
select * from library_branch

select Branch_Name,count(Book_Id)from
(select lb.BranchName as Branch_Name, bl.BookId as Book_Id from library_branch lb
left join book_loans bl
on lb.BranchId = bl.BranchId) as a group by Branch_Name 

--7)Retrieve the names, addresses, and number of books checked out for all borrowers who have more than three books checked out

select * from book_loans
select * from borrower

select Name,Addresss,count(No_as_Book) as 'No of book' from(
select bo.Name as Name, bo.Address as Addresss,bl.BookId as No_as_Book from borrower bo
left join book_loans bl
on bo.CardNo = bl.CardNo) as a group by Name,Addresss 

--8)For each book authored by "Stephen King" or co-authored with "Stephen King" , retrieve the title and the number of copies owned by the library branch whose name is
--"Central" or "Sharpstown"
select * from book
select * from book_copies
select * from library_branch

select Title,
No_of_Copies
from book bo
left join book_copies bc
on bo.bookid = bc.bookid
left join library_branch lb
on bc.branchid = lb.branchid
where lb.branchname in('Central','Sharpstown') and bo.bookid in(select bookid from book_authors where authorname ='Stephen King')