class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :check_participant

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      # Redirect back to the conversation with a success notice
      redirect_to @conversation, notice: 'تم إرسال الرسالة بنجاح'
    else
      # If message fails to save, show error and redirect back
      redirect_to @conversation, alert: 'حدث خطأ في إرسال الرسالة: ' + @message.errors.full_messages.join(', ')
    end
  end

  def index
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    render json: @messages
  end

  def mark_as_read
    @message = @conversation.messages.find(params[:id])
    @message.update(read: true)
    head :ok
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def check_participant
    # Ensure the current user is part of this conversation
    unless @conversation.buyer == current_user || @conversation.seller == current_user
      redirect_to conversations_path, alert: 'غير مصرح لك بالوصول إلى هذه المحادثة'
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
