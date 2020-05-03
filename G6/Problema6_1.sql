--Probema 6.1)
--a)
SELECT * FROM authors;

--b)
SELECT au_fname, au_lname,phone FROM authors;

--c)
SELECT au_fname, au_lname,phone FROM authors ORDER BY au_fname,au_lname;

--d)
SELECT au_fname AS first_name, au_lname AS last_name,phone AS telephone FROM authors ORDER BY au_fname,au_lname;

--e)
SELECT au_fname AS first_name, au_lname AS last_name,phone AS telephone FROM authors WHERE state = 'CA' AND au_lname != 'Ringer' ORDER BY au_fname,au_lname;

--f)
SELECT * FROM publishers WHERE pub_name LIKE '%Bo%';

--g)
SELECT DISTINCT pub_name FROM (publishers JOIN titles ON publishers.pub_id=titles.pub_id) WHERE type = 'Business';

--h)
SELECT DISTINCT pub_name,sum(ytd_sales) FROM publishers JOIN titles ON publishers.pub_id = titles.pub_id  GROUP BY pub_name;

--i)
SELECT DISTINCT title,sum(ytd_sales) FROM publishers JOIN titles ON publishers.pub_id = titles.pub_id WHERE ytd_sales != 0 GROUP BY title;

--j)
SELECT DISTINCT title,stor_name FROM titles JOIN (SELECT title_id,stor_name FROM sales JOIN stores ON sales.stor_id=stores.stor_id WHERE stor_name = 'Bookbeat') AS ss ON titles.title_id = ss.title_id;

--k) 
SELECT au_fname,au_lname FROM titles JOIN (SELECT au_fname,au_lname,title_id FROM authors JOIN titleauthor ON authors.au_id=titleauthor.au_id) AS aut ON titles.title_id=aut.title_id 
	GROUP BY au_fname,au_lname 
	HAVING count(titles.type) > 1; 
--l)
SELECT DISTINCT type,avg(price) as avg_price ,sum(qty) as total_sales  FROM titles join sales ON titles.title_id=titles.title_id GROUP BY type, titles.pub_id ; 

--m)
SELECT type FROM titles GROUP BY type HAVING max(advance)>1.5*avg(advance);

--n)
SELECT DISTINCT title,au_fname,au_lname, price*ytd_sales*(royalty/100.0)*(royaltyper/100.0) as valor_arrecadado FROM titles JOIN (SELECT au_fname,au_lname,title_id,royaltyper FROM authors JOIN titleauthor ON authors.au_id=titleauthor.au_id) AS ta ON titles.title_id=ta.title_id WHERE ytd_sales > 0;

--o)
SELECT DISTINCT title,ytd_sales,
	price*ytd_sales as faturacao_total,
	price*ytd_sales*(royalty/100.0)*(royaltyper/100.0) as faturacao_autor,
	(price*ytd_sales) - (price*ytd_sales*(royalty/100.0)*(royaltyper/100.0)) as faturacao_pub
	FROM titles JOIN titleauthor ON titles.title_id=titleauthor.title_id WHERE ytd_sales > 0;

--p)
SELECT DISTINCT title,ytd_sales,
	concat(au_fname,' ',au_lname ) as author,
	price*ytd_sales*(royalty/100.0)*(royaltyper/100.0) as faturacao_autor,
	(price*ytd_sales) - (price*ytd_sales*(royalty/100.0)*(royaltyper/100.0)) as faturacao_pub
	FROM titles JOIN (SELECT au_fname,au_lname,royaltyper,title_id FROM titleauthor JOIN authors ON authors.au_id=titleauthor.au_id) AS taa ON titles.title_id=taa.title_id WHERE ytd_sales > 0;

--q)
SELECT stor_name, count(sales.title_id) FROM sales JOIN stores ON sales.stor_id=stores.stor_id WHERE qty>0
	GROUP BY stores.stor_name
	HAVING count(sales.title_id) = (SELECT count(DISTINCT title_id) FROM titles);


--r)
SELECT stores.stor_name, sum(sales.qty) as num_sales FROM sales JOIN stores ON sales.stor_id=stores.stor_id
	GROUP BY stores.stor_name
	HAVING sum(sales.qty) > (SELECT sum(qty)/count( DISTINCT stor_id) FROM sales)


--s)
SELECT title FROM stores JOIN (SELECT title,stor_id FROM titles JOIN sales ON titles.title_id=sales.title_id) AS ts ON stores.stor_id=ts.stor_id WHERE stor_name != 'Bookbeat';

--t)
SELECT pub_name, stor_id FROM publishers,stores GROUP BY pub_name,stor_id EXCEPT 
	SELECT pub_name, stores.stor_id FROM stores JOIN (SELECT pub_name,stor_id FROM sales JOIN (SELECT pub_name,title_id FROM publishers JOIN titles ON publishers.pub_id=titles.pub_id) AS pt ON sales.title_id=pt.title_id) AS spt ON stores.stor_id=spt.stor_id
	GROUP BY pub_name,stores.stor_id