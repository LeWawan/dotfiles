(call_expression
  (member_expression
    object: (identifier) @object (#eq? @object "mysql")
    property: (property_identifier) @property (#eq? @property "query"))

(arguments
  (template_string) @sql)
  (#offset! @sql 1 0 0 0))
