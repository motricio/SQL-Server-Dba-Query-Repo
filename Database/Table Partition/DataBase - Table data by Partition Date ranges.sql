use CoreIssue;
with pf (value,Id_Partition) as
(
 SELECT value, $partition.[pfMonthlyPartition_PROD_CI](CAST(VALUE AS DATETIME)) as Id_Partition FROM sys.partition_range_values 
)

SELECT
 t.name
,fg.data_space_id
,fg.name AS filegroup_name
,pf.value as [pf_range]
,SUM(p.rows) AS rows
,SUM(b.total_pages) * 8/1024 AS TotalSpaceMB
,SUM(b.used_pages) * 8/1024 AS UsedSpaceMB
,CAST((SUM(CAST(b.total_pages AS numeric(12,2)) * 8/1024)/1024) AS numeric(12,2)) AS TotalSpaceGB
,CAST((SUM(CAST(b.used_pages AS DECIMAL(12,2)) * 8/1024)/1024 ) AS numeric(12,2)) AS UsedSpaceGB

FROM 
sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id
INNER JOIN sys.partition_schemes ps ON i.data_space_id=ps.data_space_id
LEFT OUTER JOIN sys.destination_data_spaces dds ON ps.data_space_id=dds.partition_scheme_id AND p.partition_number=dds.destination_id
INNER JOIN sys.filegroups fg ON COALESCE(dds.data_space_id, i.data_space_id)=fg.data_space_id
INNER JOIN sys.allocation_units b ON (p.partition_id = b.container_id)
INNER JOIN pf ON (p.partition_number = pf.Id_Partition)
GROUP BY
t.name,
fg.data_space_id,
pf.value,
fg.name
