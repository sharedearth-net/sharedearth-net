module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def it_should_require_signed_in_user_for_actions(*actions)
      actions = controller_class.action_methods if actions.first == :all
      actions.delete("missing_route")
      actions.each do |action|
        it "#{action} action should require signed in user" do
          #as_signed_out_visitor
          get action.to_sym, :id => 1
          response.should redirect_to(root_path)
          flash[:alert].should eql(I18n.t('messages.must_be_signed_in'))
        end
      end
    end
  end
  
  def sign_in_as_user(user)
    controller.stub(:current_user).and_return(user)
    controller.stub(:authenticate_user!).and_return(true)
  end

  def as_signed_out_visitor
    controller.stub(:authenticate_user!).and_return(false)
  end

  # def login_as_admin
    # user = User.new(:username => "admin", :email => "admin@example.com", :password => "secret")
    # user.admin = true
    # user.save!
    # session[:user_id] = user.id
    # controller.stub!(:current_user).and_return(signedin_user)
    # controller.should_receive(:authenticate_user!)
  # end
end
