# Neo4j tutorial

## Running locally (your very own Monarch Graph)

### Check out the repository

https://github.com/monarch-initiative/monarch-neo4j

### Download Data and plugins

Download [monarch.neo4j.dump](https://data.monarchinitiative.org/monarch-kg-dev/latest/monarch-kg.neo4j.dump) from https://data.monarchinitiative.org/monarch-kg-dev/latest/index.html and put in the `dumps` directory

download https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.4.0.13/apoc-4.4.0.13-all.jar
and put in the `plugins` directory

download, https://graphdatascience.ninja/neo4j-graph-data-science-2.3.0.zip, unzip and copy jar file to the `plugins` directory

## (maybe) shared neo4j portal ?

## Querying

### Return details for a single disease

Nodes in a cypher query are expressed with `()` and the basic form of a query is `MATCH (n) RETURN n`. To limit the results to just our disease of interest, we can restrict by a property, in this case the `id` property.

```cypher
MATCH (d {id: 'MONDO:0007038'}) RETURN d
```

This returns a single bubble, but by exploring the controls just to the left of the returned query, you can see a json or table representation of the returned node.

```json
{
  "identity": 480388,
  "labels": [
    "biolink:Disease",
    "biolink:NamedThing"
  ],
  "properties": {
    "name": "Achoo syndrome",
    "provided_by": [
      "phenio_nodes"
    ],
    "id": "MONDO:0007038",
    "category": [
      "biolink:Disease"
    ]
  },
  "elementId": "480388"
}
```

### Connections out from our disease

Clicking back to the graph view, you can expand to see direct connections out from the node by clicking on the node and then clicking on the graph icon. This will return all nodes connected to the disease by a single edge. 

> Tip: the node images may not be labeled the way you expect. Clicking on the node reveals a panel on the right, clicking on that node label at the top of the panel will reveal a pop-up that lets you pick which property is used as the caption in the graph view.

### Querying for connections out from our disease

In cypher, nodes are represented by `()` and edges are represented by `[]` in the form of `()-[]-()`, and your query is a little chance to express yourself with ascii art. To get the same results as the expanded graph view, you can query for any edge connecting to any node. Note that the query also asks for the connected node to be returned.

```cypher
MATCH (d {id: 'MONDO:0007038'})-[]-(n) RETURN d, n
```

### Expanding out further and restricting the relationship direction

It's possible to add another edge to the query to expand out further. In this case, we're adding a second edge to the query, and restricting the direction of the second edge to be outgoing. This will return all nodes connected to the disease by a single edge, and then all nodes connected to those nodes by a single outgoing edge. It's important to note that without limiting the direction of the association, this query will traverse up, and then back down the subclass tree.  

```cypher
MATCH (d {id: 'MONDO:0007038'})-[]->(n)-[]->(m) RETURN d,n,m
```

## Exploring the graph schema

Sometimes, we don't know what kind of questions to ask without seeing the shape of the data. Neo4j provides a graph representation of the schema by calling a procedure

```cypher
CALL db.schema.visualization
```

If you tug on nodes and zoom, you may find useful information, but it's not a practical way to explore the schema.

### What's connected to a gene?

We can explore the kinds of connections available for a given category of node. Using property restriction again, but this time instead of restricting by the ID, we'll restrict by the category. Also, instead of returning nodes themselves, we'll return the categories of those nodes. 

```cypher
MATCH (g:`biolink:Gene`)-[]->(n) RETURN DISTINCT labels(n)
```

> Tip: the `DISTINCT` keyword is used to remove duplicate results. In this case, we're only interested in the unique categories of nodes connected to genes.

### Also, how is it connected?

Expanding on the query above, we can also return the type of relationship connecting the gene to the node.

```cypher
MATCH (g:`biolink:Gene`)-[rel]->(n) RETURN DISTINCT type(rel), labels(n)
```

> Note: the DISTINCT keyword will only remove duplicate results if the entire result is the same. In this case, we're interested in the unique combinations of relationship type and node category.



