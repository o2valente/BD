USE pubs;
GO

--5)
-- i)
CREATE VIEW BOOKS(title, author) AS
	SELECT t.title, a.au_fname + ' ' + a.au_lname
	FROM titles AS t JOIN titleauthor AS ta ON t.title_id = ta.title_id
		JOIN authors AS a ON a.au_id = ta.au_id;
GO

-- ii)
CREATE VIEW EMPLOYEES(pub_name, empl_name) AS
	SELECT p.pub_name, e.fname + ' ' + e.minit + '. ' + e.lname
	FROM publishers AS p JOIN employee AS e ON p.pub_id = e.pub_id;
GO

-- iii)
CREATE VIEW STORE_TITLES(store_name, book_title) AS
	SELECT st.stor_name, t.title
	FROM stores AS st JOIN sales AS s ON st.stor_id=s.stor_id JOIN titles AS t ON s.title_id = t.title_id;
GO

-- iv)
CREATE VIEW BUSINESS_TITLES(title_id, title, [type], pub_id, price, notes) AS
	SELECT t.title_id,t.title,t.[type],t.pub_id,t.price,t.notes
	FROM titles AS t
	WHERE t.[type] = 'Business'
	WITH CHECK OPTION;
GO


--b)
--i
SELECT * 
FROM BOOKS
WHERE title = 'The Gourmet Microwave';

-- ii)
SELECT * 
FROM EMPLOYEES
WHERE empl_name = 'Philip';

-- iii)
SELECT * 
FROM STORE_TITLES
WHERE store_name = 'Eric the Read Books';

-- iv)
SELECT * 
FROM BUSINESS_TITLES
WHERE price = 7.99;


--c)

GO
CREATE VIEW VIEW_STORE_AUTHOR(title, author) AS
SELECT stores.stor_name, authors.au_Fname + ' ' + authors.au_lname
FROM titles JOIN titleauthor ON titles.title_id = titleauthor.title_id
JOIN authors ON titleauthor.au_id = authors.au_id
JOIN sales ON titles.title_id = sales.title_id
JOIN stores ON stores.stor_id = sales.stor_id
GO


--d)

--i) Não.