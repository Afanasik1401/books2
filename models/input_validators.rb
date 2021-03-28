# frozen_string_literal: true

# Validators for the incoming requests
module InputValidators
  def self.check_date_format(date)
    if /\d{4}-\d{2}-\d{2}/ =~ date
      []
    else
      ['Дата должна быть передана в формате ГГГГ-ММ-ДД']
    end
  end

  def self.check_book(raw_name, raw_date, raw_author)
    name = raw_name || ''
    date = raw_date || ''
    author = raw_author || ''
    errors = [].concat(check_name(name))
               .concat(check_date(date))
               .concat(check_author(author))
               .concat(check_date_format(date))
               .concat(check_correct_date(date))
    {
      name: name,
      date: date,
      author: author,
      errors: errors
    }
  end

  def self.check_name(name)
    if name.empty?
      ['Название книги  не может быть пустым']
    else
      []
    end
  end

  def self.check_author(author)
    if author.empty?
      ['Имя автора не может быть пустым']
    else
      []
    end
  end

  def self.check_date(date)
    if date.empty?
      ['Дата не может быть пустой']
    else
      []
    end
  end

  def self.check_correct_date(date)
    ardate = date.split('-').map(&:to_i)
    if date.empty?
      ['Дата не может быть пустой']
    elsif (ardate[0] > 2020) || (ardate[0] < 1)
      ['Год не может быть больше 2020 или меньше 1']
    elsif (ardate[1] < 1) || (ardate[1] > 12)
      ['Месяц не может быть больше 12 или меньше 1']
    elsif (ardate[2] < 1) || (ardate[2] > 31)
      ['День не может быть больше 31 или меньше 1']
    else
      []
    end
  end
end
