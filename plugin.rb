# name: discourse-knowledge-explorer
# about: A plugin to make it easy to explore and find knowledge base-type articles in Discourse
# version: 0.1
# author: Justin DiRose
# license: 
# url: 

enabled_site_setting :knowledge_explorer_enabled

load File.expand_path('../lib/knowledge_explorer/engine.rb', __FILE__)
