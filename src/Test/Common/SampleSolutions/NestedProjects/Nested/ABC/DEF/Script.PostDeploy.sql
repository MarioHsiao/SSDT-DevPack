﻿/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
MERGE INTO dbo.TheTable
 AS TARGET
USING (VALUES (1, 'Ed', 1), (2, 'Ian', 0)) AS SOURCE(Id, name, fun) ON SOURCE.[Id] = TARGET.[Id]
WHEN NOT MATCHED BY TARGET THEN INSERT (Id, name, fun) VALUES (SOURCE.Id, SOURCE.name, SOURCE.fun)
WHEN MATCHED AND (NULLIF (SOURCE.fun, TARGET.fun) IS NOT NULL
                  OR NULLIF (SOURCE.name, TARGET.name) IS NOT NULL
                  OR NULLIF (SOURCE.Id, TARGET.Id) IS NOT NULL) THEN UPDATE 
SET TARGET.Id   = SOURCE.Id,
    TARGET.name = SOURCE.name,
    TARGET.fun  = SOURCE.fun
WHEN NOT MATCHED BY SOURCE THEN DELETE;