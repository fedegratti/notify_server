# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: %i[show update destroy]

  # GET /notifications
  def index
    @notifications = Notification.where(user: current_user)

    render json: @notifications
  end

  # GET /notifications/1
  def show
    render json: @notification
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    @notification.user = current_user

    if @notification.save
      Notifications::Send.call(@notification)

      render json: @notification, status: :created, location: @notification
    else
      render json: @notification.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /notifications/1
  def update
    if @notification.update(notification_params)
      render json: @notification
    else
      render json: @notification.errors, status: :unprocessable_content
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_notification
    @notification = Notification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def notification_params
    params.require(:notification).permit(:title, :content, :channel)
  end
end
