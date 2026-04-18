require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
    def setup
        @article = create(:article, :draft)
    end

    test "list articles success" do
        get articles_url
        assert_response :success
    end

    test "show article success" do
        get article_url(@article.id)
        assert_response :success
    end

    test "show article raise not found exception" do
        get article_url(123)
        assert_response :not_found
    end

    test "create article success" do
        assert_difference("Article.count", 1) do
            post articles_url, params: {
                article: {
                    title: "New title",
                    body: "Body for article"
                }
            }
            assert_response :success
            assert_equal @controller.instance_variable_get(:@article).valid?, true
        end
    end

    test "create article error validations" do
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

    test "update article success" do
        patch article_url(@article.id), params: {
            article: {
                title: "Updated article title"
            }
        }
        assert_equal @controller.instance_variable_get(:@article).valid?, true
        assert_equal @article.reload.title, "Updated article title"
        assert_response :success
    end

    test "update article error validations" do
        patch article_url(@article.id), params: {
            article: {
                title: ""
            }
        }
        assert_equal @controller.instance_variable_get(:@article).valid?, false
        assert_equal @article.reload.title, @article.title
        assert_response :unprocessable_entity
    end

    test "update article raise not found exception" do
        patch article_url(123), params: {
            article: {
                title: "Updated article title"
            }
        }
        assert_response :not_found
    end

    test "destroy article success" do
        assert_difference("Article.count", -1) do
            delete article_url(@article.id)
            assert_response :success
        end
    end

    test "destroy article raise not found exception" do
        delete article_url(123)
        assert_response :not_found
    end
end