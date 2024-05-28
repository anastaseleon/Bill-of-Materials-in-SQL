USE adventureworks2019

go

WITH bom_cte (productassemblyid, componentid, perassemblyqty, startdate, enddate
     ,
     bomlevel)
     AS (
        -- Anchor member
        SELECT b.productassemblyid,
               b.componentid,
               b.perassemblyqty,
               b.startdate,
               b.enddate,
               0 AS BOMLevel -- sets the first level at 0
        FROM   production.billofmaterials b
        WHERE  b.productassemblyid = 747
               AND enddate IS NULL
         UNION ALL
         -- Recursive member
         SELECT b.productassemblyid,
                b.componentid,
                b.perassemblyqty,
                b.startdate,
                b.enddate,
                c.bomlevel + 1
         FROM   production.billofmaterials b
                INNER JOIN bom_cte c
                        ON b.productassemblyid = c.componentid)
SELECT *
FROM   bom_cte
WHERE  enddate IS NULL; 
