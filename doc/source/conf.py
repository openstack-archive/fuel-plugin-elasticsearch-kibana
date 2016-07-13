extensions = []
templates_path = ['_templates']

source_suffix = '.rst'

master_doc = 'index'

project = u'The StackLight Elasticsearch-Kibana Plugin for Fuel'
copyright = u'2015, Mirantis Inc.'

version = '0.10'
release = '0.10.0'

exclude_patterns = []

pygments_style = 'sphinx'

html_theme = 'default'
html_static_path = ['_static']

latex_documents = [
  ('index', 'ElasticsearchKibana.tex', u'The StackLight Elasticsearch-Kibana Plugin for Fuel Documentation',
   u'Mirantis Inc.', 'manual'),
]

# make latex stop printing blank pages between sections
# http://stackoverflow.com/questions/5422997/sphinx-docs-remove-blank-pages-from-generated-pdfs
latex_elements = {'classoptions': ',openany,oneside', 'babel':
                  '\\usepackage[english]{babel}'}
