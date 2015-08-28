module NameDecorator
  def first_name
    name_pieces.first
  end

  def last_name
    name_pieces.last
  end

  private

  def name_pieces
    name.split(' ')
  end
end
