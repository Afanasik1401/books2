# frozen_string_literal: true
require 'forme'
require 'roda'
require_relative 'models'

# The core class of the web application for managing books
class BookApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :render
  configure :development do
    plugin :public
    opts[:serve_static] = true
  end
  opts[:books] = BookList.new([
                                Book.new('Горе от ума', 'Грибоедов', '2020-04-05'),
                                Book.new('Мастер и Маргарита', 'Булгаков', '2020-04-20'),
                                Book.new('Бородино', 'Лермонтов', '2020-06-20'),
                                Book.new('Над пропастью во ржи', 'Сэлинджер', '2019-07-21'),
                                Book.new('Шерлок Холмс', ' Артур Конан Дойл', '2019-05-20'),
                                Book.new('1984', 'Джордж Оруэлл ', '2009-05-20'),
                                Book.new('Граф Монте-Кристо', 'Александр Дюма ', '2009-05-20'),
                                Book.new('Маленький принц', 'Антуан де Сент-Экзюпери ', '2009-07-21'),
                                Book.new('Анна Каренина', 'Лев Толстой', '2000-05-20')
                              ])
  route do |r|
    r.public if opts[:serve_static]
    r.on 'books' do
      r.is do
        @books = opts[:books].sort_by_date
        view('books')
      end
      r.on 'statistics' do
        r.get do
          @books = opts[:books].sort_by_date
          @years = opts[:books].years
          view('statistics')
        end
      end
      r.get Integer do |year|
        @books = opts[:books].sort_by_date
        @year = year
        view('info')
      end
      r.on 'new' do
        r.get do
          @params = {}
          view('new_book')
        end
        r.post do
          @params = DryResultFormeAdapter.new(NewBookFormSchema.call(r.params))
          if @params.success?
            opts[:books].add_book(Book.new(@params[:name], @params[:author], @params[:date]))
            r.redirect '/books'
          else
            view('new_book')
          end
        end
      end
    end
  end
end
