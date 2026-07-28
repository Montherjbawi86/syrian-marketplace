class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = Conversation.where('buyer_id = ? OR seller_id = ?', current_user.id, current_user.id)
                                 .includes(:listing, :buyer, :seller, :messages)
                                 .order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @messages.where.not(user_id: current_user.id).update_all(read: true)
    @message = Message.new
  end

  def new
    @listing = Listing.find(params[:listing_id])

    # Don't allow conversation with yourself
    if @listing.user == current_user
      redirect_to @listing, alert: 'لا يمكنك مراسلة نفسك'
      return
    end

    @conversation = Conversation.find_or_initialize_by(
      listing: @listing,
      buyer: current_user,
      seller: @listing.user
    )

    if @conversation.persisted?
      redirect_to @conversation
    end
  end

  def create
    @listing = Listing.find(params[:listing_id])

    # Don't allow conversation with yourself
    if @listing.user == current_user
      redirect_to @listing, alert: 'لا يمكنك مراسلة نفسك'
      return
    end

    @conversation = Conversation.find_or_create_by(
      listing: @listing,
      buyer: current_user,
      seller: @listing.user
    )

    # Create initial message if provided
    if params[:message].present?
      @conversation.messages.create(
        user: current_user,
        content: params[:message]
      )
    end

    redirect_to @conversation
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
    unless @conversation.buyer == current_user || @conversation.seller == current_user
      redirect_to conversations_path, alert: 'غير مصرح لك بالوصول إلى هذه المحادثة'
    end
  end
end
