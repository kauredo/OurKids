class ExpensesController < ApplicationController
  before_action :find_family, only: [:index, :show, :edit, :update]
  layout 'devise', only: [:show]

  def index
    @expenses = @family.expenses.order(date: :desc).distinct
    @categories = Category.all.map { |c| c.name }
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    @category = Category.find(params[:expense][:category]) unless params[:expense][:category].empty?
    @expense.category = @category unless @category.nil?
    if @expense.update(expense_params)
      redirect_to expense_family_path(@family, @expense)
    else
      render :edit
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :description, :date, :percentage, :receipt, :amount)
  end

  def find_family
    @family = Family.find(params[:family_id])
  end
end
