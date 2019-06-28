module KnowledgeExplorer
  class KnowledgeExplorerController< ApplicationController
    skip_before_action :check_xhr
    before_action :init_guardian

    def index
      category_topic_lists = []
      tag_topic_lists = []

      knowledge_explorer_categories.each do |c|
        if topic_list = TopicQuery.new(current_user, category: c.id).list_latest
          category_topic_lists << TopicListSerializer.new(topic_list, scope: @guardian).as_json
        end
      end

      knowledge_explorer_tags.each do |t|
        if topic_list = TopicQuery.new(current_user, tags: t.name).list_latest
          tag_topic_lists << TopicListSerializer.new(topic_list, scope: @guardian).as_json
        end
      end

      topics = []

      category_topic_lists.each do |list|
        list[:topic_list][:topics].each do |t| 
          if !topics.any?{|item| item[:id] == t[:id]}
            if t[:id] != Category.find(t[:category_id]).topic_id
              topics << t
            end
          end
        end
      end
      tag_topic_lists.each do |list|
        list[:topic_list][:topics].each do |t| 
          if !topics.any?{|item| item[:id] == t[:id]}
            topics << t
          end
        end
      end

      render json: topics
    end

    private

    def init_guardian
      @guardian = Guardian.new(current_user)
    end
    
    def knowledge_explorer_categories
      selected_categories = SiteSetting.knowledge_explorer_categories.split("|")

      categories = Category.where('slug IN (?)', selected_categories)

      categories.select { |c| @guardian.can_see_category?(c) }
    end

    def knowledge_explorer_tags
      selected_tags = SiteSetting.knowledge_explorer_tags.split("|")

      tags = Tag.where('name IN (?)', selected_tags)
    end
  end
end
