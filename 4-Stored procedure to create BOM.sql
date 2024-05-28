USE [AdventureWorks2019]
GO


CREATE PROCEDURE GenerateBOM
    @AssemblyIDList NVARCHAR(MAX)
AS
BEGIN
    -- Declare a table variable to hold the parsed Assembly IDs
    DECLARE @AssemblyIDs TABLE (AssemblyID INT);

    -- Parse the input list of Assembly IDs into the table variable
    INSERT INTO @AssemblyIDs (AssemblyID)
    SELECT value
    FROM STRING_SPLIT(@AssemblyIDList, ',');

    -- Recursive CTE to generate the BOM
    WITH BOM_CTE (ProductAssemblyID, ComponentID, PerAssemblyQty, StartDate, EndDate, BOMLevel) AS (
        -- Anchor member
        SELECT  
            b.ProductAssemblyID,  
            b.ComponentID,  
            b.PerAssemblyQty,  
            b.StartDate,  
            b.EndDate,  
            0 AS BOMLevel 
        FROM  
            Production.BillOfMaterials b 
        WHERE  
            b.ProductAssemblyID IN (SELECT AssemblyID FROM @AssemblyIDs) AND EndDate IS NULL 

        UNION ALL 

        -- Recursive member
        SELECT  
            b.ProductAssemblyID,  
            b.ComponentID,  
            b.PerAssemblyQty,  
            b.StartDate,  
            b.EndDate,  
            c.BOMLevel + 1 
        FROM  
            Production.BillOfMaterials b 
        INNER JOIN  
            BOM_CTE c ON b.ProductAssemblyID = c.ComponentID
    )

    -- Select the final BOM result into a view
    SELECT * 
    INTO BOM_View
    FROM BOM_CTE  
    WHERE EndDate IS NULL;

    -- Inform the user about the creation of the view
    PRINT 'BOM_View created successfully.';
END;
GO


