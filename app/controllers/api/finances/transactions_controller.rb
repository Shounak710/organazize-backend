# frozen_string_literal: true

class Api::Finances::TransactionsController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    use_case = ::Finances::Transactions::IndexCase.new(page_parameters: page_parameters,
                                                       filter_parameters: filter_parameters)
    result = use_case.perform

    render json: result.items, meta: result.pagination, meta_key: :pagination, each_serializer: ::Finances::TransactionSerializer
  end

  def create
    use_case = ::Finances::Transactions::CreateCase.new(transaction_params)

    result = use_case.perform

    render json: result, serializer: ::Finances::TransactionSerializer
  end

  def show
    use_case = ::Finances::Transactions::ShowCase.new(transaction: @transaction)

    result = use_case.perform

    render json: result, serializer: ::Finances::TransactionSerializer
  end

  def update
    use_case = ::Finances::Transactions::UpdateCase.new(transaction_params.merge(transaction: @transaction))

    result = use_case.perform

    if result.errors.any?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: result.record, serializer: ::Finances::TransactionSerializer, status: :ok
    end
  end

  def destroy
    use_case = ::Finances::Transactions::DestroyCase.new(transaction: @transaction)

    result = use_case.perform

    if result.errors.any?
      render json: { errors: result.errors }, status: :unprocessable_entity
    else
      render json: result.record, serializer: ::Finances::TransactionSerializer, status: :ok
    end
  end

  private

    def transaction_params
      params.require(:transaction).permit(:amount_paid,
                                          :return_amount,
                                          :method,
                                          :card_type
                                        )
    end

    def set_transaction
      @transaction = ::Finances::Transaction.find(params[:id])
    end

    def filter_parameters
      params.permit(:start_date, :end_date)
    end
end
  