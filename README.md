<p align="center">
  <h1 align="center">Dgraph Distributed graph database</h1>
  <p align="center">
    <a href="README.md"><strong>English</strong></a> | <strong>简体中文</strong>
  </p>
</p>

## Table of Contents

- [Repository Introduction](#repository-introduction)
- [Prerequisites](#prerequisites)
- [Image Specifications](#image-specifications)
- [Getting Help](#getting-help)
- [How to Contribute](#how-to-contribute)

## Repository Introduction
‌[Dgraph‌](https://github.com/hypermodeinc/dgraph) Dgraph is an open-source, distributed native graph database designed for efficient storage and querying of highly connected data. It uses a GraphQL-like query language (DQL) and provides horizontal scalability, making it suitable for complex relationship scenarios such as social networks, recommendation systems, and knowledge graphs.

**Core Features:**
1. Native Graph Database Design: Dgraph is a distributed database built specifically for graph data, using a directed property graph model. It supports flexible modeling of nodes (entities), edges (relationships), and properties (key-value pairs). For example, Person-(FRIEND)->Person{name:"Alice"} can directly represent a social network, naturally suitable for complex relationship queries.
2. High-Performance Distributed Architecture: Achieves multi-node data consistency based on the Raft consensus protocol, supporting horizontal scaling. Through data sharding and parallel query execution, it can handle real-time traversal of billions of nodes and edges, with throughput growing linearly with cluster size.
3. GraphQL+- Query Language: Provides a declarative query language similar to GraphQL (syntax compatible with GraphQL but extended with graph operation capabilities), supporting deep link queries, filtering, pagination, and aggregation.
4. ACID Transaction Support: Ensures strong consistency for read and write across nodes, supporting snapshot isolation levels. Transactions can batch operate multiple nodes/edges, such as updating user information and friend relationships simultaneously, ensuring data integrity.
5. Real-Time Incremental Backup and Recovery: Achieves full backups through Export/Import mechanisms, combined with WAL (Write-Ahead Log) for incremental data synchronization, allowing quick rollback to a specified point in time during disaster recovery.
6. Multi-Language Client Support: Officially provides client drivers for languages such as Go, Java, Python, and JavaScript, while also supporting gRPC and HTTP APIs, facilitating integration into existing technology stacks.
7. Intelligent Indexing and Query Optimization: Automatically creates optimized indexes for frequently queried fields (such as @id, @index), supporting full-text search (@fulltext), fuzzy matching, and geospatial queries. The query planner dynamically optimizes execution paths, reducing graph traversal overhead.
8. Cloud-Native and Kubernetes Integration: Provides Helm Charts and Operators to simplify K8s deployment, supporting dynamic scaling, health checks, and monitoring metrics exposure (in Prometheus format), suitable for elastic needs in cloud environments.
9. Fine-Grained Permission Control: Implements field-level access control based on JWT or custom authentication logic (such as restricting users to query only their own friend data), meeting compliance requirements like GDPR.
10. Real-Time Subscriptions (Live Queries): Clients can subscribe to graph data change events (such as newly added nodes or edges), with updates pushed in real-time to front-end applications, suitable for scenarios like social dynamics and fraud detection.

This project offers pre-configured [**`Dgraph-Distributed graph database`**]()，images with Dgraph and its runtime environment pre-installed, along with deployment templates. Follow the guide to enjoy an "out-of-the-box" experience.

**Architecture Design:**

![](./images/img.png)

> **System Requirements:**
> - CPU: 4vCPUs or higher
> - RAM: 16GB or more
> - Disk: At least 50GB

## Prerequisites
[Register a Huawei account and activate Huawei Cloud](https://support.huaweicloud.com/usermanual-account/account_id_001.html)

## Image Specifications

| Image Version          | Description | Notes |
|------------------------| --- | --- |
| [Dgraph24.1.3-arm-v1.0](https://github.com/HuaweiCloudDeveloper/dgraph-image/tree/Dgraph24.1.3-arm-v1.0?tab=readme-ov-file) | Deployed on Kunpeng servers with Huawei Cloud EulerOS 2.0 64bit |  |

## Getting Help
- Submit an [issue](https://github.com/HuaweiCloudDeveloper/dgraph-image/issues)
- Contact Huawei Cloud Marketplace product support

## How to Contribute
- Fork this repository and submit a merge request.
- Update README.md synchronously based on your open-source mirror information.