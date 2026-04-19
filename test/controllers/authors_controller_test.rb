require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
    def setup
        @author = create(:author)
    end

    test "List authors - Success" do
        get authors_url
        assert_response :success
    end

    test "Show author - Success" do
        get author_url(@author.id)
        assert_response :success
    end

    test "Show author - Raise not found exception" do
        get author_url(123)
        assert_response :not_found
    end

    test "Create author - Success" do
        assert_difference("Author.count", 1) do
            post authors_url, params: {
                author: {
                    name: "Name",
                    email: "name@gmail.com",
                    city: "Example",
                    birth_date: "1997-08-31",
                }
            }
            assert_response :success
            assert_equal @controller.instance_variable_get(:@author).valid?, true
        end
    end

    test "Create author - Author validations" do
        assert_difference("Author.count", 0) do
            post authors_url, params: {
                author: {
                    name: "",
                    email: "name@gmail.com",
                    city: "Example",
                    birth_date: "1997-08-31"
                }
            }
            assert_response :unprocessable_entity
            assert_equal @controller.instance_variable_get(:@author).valid?, false
        end
    end

    test "Update author - Success" do
        patch author_url(@author.id), params: {
            author: {
                name: "Updated name"
            }
        }
        assert_equal @controller.instance_variable_get(:@author).valid?, true
        assert_equal @author.reload.name, "Updated name"
        assert_response :success
    end

    test "Update author - Error validations" do
        patch author_url(@author.id), params: {
            author: {
                name: ""
            }
        }
        assert_equal @controller.instance_variable_get(:@author).valid?, false
        assert_equal @author.reload.name, @author.name
        assert_response :unprocessable_entity
    end

    test "Update author - Raise not found exception" do
        patch author_url(123), params: {
            author: {
                name: "Updated name"
            }
        }
        assert_response :not_found
    end

    test "Destroy author - Success" do
        assert_difference("Author.count", -1) do
            delete author_url(@author.id)
            assert_response :success
        end
    end

    test "Destroy author - Raise not found exception" do
        delete author_url(123)
        assert_response :not_found
    end
end
