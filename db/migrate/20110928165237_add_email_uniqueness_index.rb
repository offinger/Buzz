class AddEmailUniquenessIndex < ActiveRecord::Migration
 # This uses a Rails method called add_index to add an index on the email column of the
 #  users table. The index by itself doesn’t enforce uniqueness, but the option :unique
 # => true does.
 #u slucaju da korisnik pri registraciji unese adrese koju hoce i dva puta brzo pritisne potvrdi(prihvati, sta god) adresa ce biti dva puta upisana, sama uniques metoda to ne moze srediti ali zato postavljanje indexa na zeljenu kolonu u bazi, u ovom slucaju users=>email unique=>true to obezbedjuje, naravno u kombinaciji sa metodom uniqueness
#stavljanje indexa na kolonu u bazi pospesuje takodje i brzinu pretrazivanja baze:  
#To understand a database index, it’s helpful to consider the analogy of a book index. In a book, to find all the occurrences of a given string, say ‘‘foobar’’, you would have to scan each page for ‘‘foobar’’. With a book index, on the other hand, you can just look up ‘‘foobar’’ in the index to see all the pages containing ‘‘foobar’’. A database index works essentially the same way.
  def self.up
   add_index :users, :email, :unique => true
  end
  def self.down
   remove_index :users, :email
  end
 end
