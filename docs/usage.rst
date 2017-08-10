.. -*- coding: utf-8 -*-
.. :Project:   pg_query -- Usage
.. :Created:   gio 10 ago 2017 10:06:38 CEST
.. :Author:    Lele Gaifax <lele@metapensiero.it>
.. :License:   GNU General Public License version 3 or later
.. :Copyright: © 2017 Lele Gaifax
..

===================
 Examples of usage
===================

* Parse an ``SQL`` statement and get its *AST* root node:

  .. doctest::

     >>> from pg_query import Node, parse_sql
     >>> root = Node(parse_sql('SELECT foo FROM bar'))
     >>> print(root)
     None=[1*{RawStmt}]

* Recursively traverse the parse tree:

  .. doctest::

     >>> for node in root.traverse():
     ...   print(node)
     ...
     None[0]={RawStmt}
     stmt={SelectStmt}
     fromClause[0]={RangeVar}
     inh=<True>
     location=<16>
     relname=<'bar'>
     relpersistence=<'p'>
     op=<0>
     targetList[0]={ResTarget}
     location=<7>
     val={ColumnRef}
     fields[0]={String}
     str=<'foo'>
     location=<7>

  As you can see, the ``repr``\ esentation of each value is mnemonic: ``{some_tag}`` means a
  ``Node`` with tag ``some_tag``, ``[X*{some_tag}]`` is a ``List`` containing `X` nodes of that
  particular kind\ [*]_ and ``<value>`` is a ``Scalar``.

* Get a particular node:

  .. doctest::

     >>> from_clause = root[0].stmt.fromClause
     >>> print(from_clause)
     fromClause=[1*{RangeVar}]

* Obtain some information about a node:

  .. doctest::

     >>> range_var = from_clause[0]
     >>> print(range_var.node_tag)
     RangeVar
     >>> print(range_var.attribute_names)
     dict_keys(['relname', 'inh', 'relpersistence', 'location'])
     >>> print(range_var.parent_node)
     stmt={SelectStmt}

* Iterate over nodes:

  .. doctest::

     >>> for a in from_clause:
     ...     print(a)
     ...     for b in a:
     ...         print(b)
     ...
     fromClause[0]={RangeVar}
     inh=<True>
     location=<16>
     relname=<'bar'>
     relpersistence=<'p'>

* Reformat a SQL statement\ [*]_ from the command line:

  .. code-block:: shell

     $ echo "select a,b,c from sometable" | python -m pg_query
     SELECT a
          , b
          , c
     FROM sometable

     $ echo 'update "table" set value=123 where value is null' | python -m pg_query
     UPDATE "table"
     SET value = 123
     WHERE value IS NULL

* Programmatically reformat a SQL statement:

  .. doctest::

     >>> from pg_query import prettify
     >>> print(prettify('delete from sometable where value is null'))
     DELETE FROM sometable
     WHERE value IS NULL


---

.. [*] This is an approximation, because in principle a list could contain different kinds of
       nodes, or even sub-lists in some cases: the ``List`` representation arbitrarily shows
       the tag of the first object.

.. [*] Currently this covers most `DML` statements such as ``SELECT``\ s, ``INSERT``\ s,
       ``DELETE``\ s and ``UPDATE``\ s, fulfilling my needs, but I'd like to extend it to
       handle also `DDL` statements and, why not, `PLpgSQL` instructions too.