require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
    def setup
        @article = create(:article, :draft)
    end

    test "List articles - Success" do
        get articles_url
        assert_response :success
    end

    test "List articles filter by title - Success" do
        create(:article, title: "Civil war")
        create(:article, title: "Inversions: Bitcoin")
        create(:article, title: "Inversions: SP500")
        get articles_url, params: {
            filters: {
                title: "inversion"
            }
        }
        articles = @controller.instance_variable_get(:@articles)
        assert_equal articles.all? { |art| art.title.downcase.include? "inversion" }, true
        assert_response :success
    end

    test "List articles filter by tag - Success" do
        create(:article, tags: [ "science", "tech" ])
        create(:article, tags: [ "tech" ])
        create(:article, tags: [ "health" ])
        get articles_url, params: {
            filters: {
                tag: "tech"
            }
        }
        articles = @controller.instance_variable_get(:@articles)
        assert_equal articles.all? { |art| art.tags.include? "tech" }, true
        assert_response :success
    end

    test "List articles filter by start date - Success" do
        create(:article, created_at: Date.today + 1.days)
        create(:article, created_at: Date.today + 5.days)
        create(:article, created_at: Date.today - 2.days)
        get articles_url, params: {
            filters: {
                start_date: Date.today.strftime("%d/%m/%Y")
            }
        }
        articles = @controller.instance_variable_get(:@articles)
        assert_equal articles.all? { |art| art.created_at >= Date.today }, true
        assert_response :success
    end

    test "List articles filter by end date - Success" do
        create(:article, created_at: Date.today + 1.days)
        create(:article, created_at: Date.today + 5.days)
        create(:article, created_at: Date.today - 2.days)
        get articles_url, params: {
            filters: {
                end_date: Date.today.strftime("%d/%m/%Y")
            }
        }
        articles = @controller.instance_variable_get(:@articles)
        assert_equal articles.all? { |art| art.created_at <= Date.today }, true
        assert_response :success
    end

    test "Show article - Success" do
        get article_url(@article.id)
        assert_response :success
    end

    test "Show article - Raise not found exception" do
        get article_url(123)
        assert_response :not_found
    end

    test "Create draft article - Success" do
        assert_difference("Article.count", 1) do
            post articles_url, params: {
                article: {
                    title: "New title",
                    body: "Body for article"
                }
            }
            assert_response :success
            assert_equal @controller.instance_variable_get(:@article).valid?, true
            assert_equal @controller.instance_variable_get(:@article).published_at.present?, false
        end
    end

    test "Create published article - Success" do
        assert_difference("Article.count", 1) do
            post articles_url, params: {
                article: {
                    title: "New title",
                    body: "Body for article",
                    published: true
                }
            }
            assert_response :success
            assert_equal @controller.instance_variable_get(:@article).valid?, true
            assert_equal @controller.instance_variable_get(:@article).published_at.present?, true
        end
    end

    test "Create article - Error validations" do
        assert_difference("Article.count", 0) do
            post articles_url, params: {
                article: {
                    title: "",
                    body: ""
                }
            }
            assert_response :unprocessable_entity
            assert_equal @controller.instance_variable_get(:@article).valid?, false
        end
    end

    test "Update article - Success" do
        patch article_url(@article.id), params: {
            article: {
                title: "Updated article title"
            }
        }
        assert_equal @controller.instance_variable_get(:@article).valid?, true
        assert_equal @article.reload.title, "Updated article title"
        assert_response :success
    end

    test "Update article - Error validations" do
        patch article_url(@article.id), params: {
            article: {
                title: ""
            }
        }
        assert_equal @controller.instance_variable_get(:@article).valid?, false
        assert_equal @article.reload.title, @article.title
        assert_response :unprocessable_entity
    end

    test "Update article - Raise not found exception" do
        patch article_url(123), params: {
            article: {
                title: "Updated article title"
            }
        }
        assert_response :not_found
    end

    test "Destroy article - Success" do
        assert_difference("Article.count", -1) do
            delete article_url(@article.id)
            assert_response :success
        end
    end

    test "Destroy article - Raise not found exception" do
        delete article_url(123)
        assert_response :not_found
    end
end
