#  Building Bronze Layer

##  Analyze Source Systems

###  a.	Business Context & Ownership
+  Who owns the data?
+  What business process it supports e.g logistics, finance, or reporting
+  System & Data documentation
+  Data Model & Data Catalog

###  b.	Architecture & Technology Stack
+  How is the data stored? (On-prem: SQL Server, Oracle; OR Cloud: AWS, Azure…)
+  What are the integration capabilities? (API, Kafka, File Extract, Direct DB…)

###  c.	Extract & Load
+  Incremental vs Ful loads
+  Data scope & Historical Needs
+  What is the expected size of the extracts?
+  Are there any data volume limitations?
+  How to avoid impacting the source system’s performance
+  Authentication and Authorization (tokens, SSH keys, VPN, IP whitelisting)
