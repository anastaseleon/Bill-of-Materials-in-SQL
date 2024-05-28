--Show the content of Production.BillOfMaterials 
USE adventureworks2019

go

SELECT TOP(10) *
FROM   production.billofmaterials

--What are the active relationships between Product assemblies and components in the dataset?
SELECT PB.billofmaterialsid,
       PB.productassemblyid,
       PP1.NAME AS ProductAssemblyName,
       PB.perassemblyqty,
       PB.componentid,
       PP.NAME  AS ComponentName
FROM   production.billofmaterials PB
       JOIN production.product PP
         ON PB.componentid = PP.productid /*Production.Product is
                                          used to get products' name */
       JOIN production.product PP1
         ON PB.productassemblyid = PP1.productid
WHERE  enddate IS NULL -- EndDate has to be null to only keep active bill of materials

  --Information about product 747
SELECT *
FROM   production.product
WHERE  productid = 747

--For what products 747 is a component 
SELECT PM.*,
       PP.NAME AS ProductAssemblyName
FROM   production.billofmaterials PM
       JOIN production.product pp
         ON PM.productassemblyid = PP.productid
WHERE  componentid = 747 
