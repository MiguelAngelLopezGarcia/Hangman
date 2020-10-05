require "yaml"


class Game

    def initialize

        @secret_word = get_random_word

        @displayable_secret_word = []

        @wrong_guesses_countdown = 6

        @wrong_letters = []

    end

    def get_random_word

        random_line = rand(61407)
        word = IO.readlines("dictionary.txt")[random_line]
        final_word = word.downcase.delete!("\n")

        if final_word.length > 12 || final_word.length < 5
            get_random_word
        else
            return final_word
        end
    end

    def start_the_game

        puts "Wellcome to the Hangman game!\nIf it you have a saved game that you want to continue type \"LOAD\", else type \"PLAY\""

        user_first_input = gets.chomp.downcase

        if user_first_input == "play"
            play_game
        elsif user_first_input == "load"

            if File.exists? ("save/save_file.dump")
                puts "Game loaded\n"
                play = YAML.load(File.read("save/save_file.dump"))
                play.display_game_in_screen
            else
                puts "Saved file not found"
                play_game
            end

        else
            start_the_game
        end

    end

    def play_game 
        
        puts "The computer will choose a random word between 5 and 12 letters and you have to guess it letter by letter"
        puts "You can save your game anytime you like by tiping \"SAVE\""

        display_game_in_screen

    end


    def display_game_in_screen 

        draw_hangman

        display_secret_word

        display_wrong_guesses

        check_end_of_the_game

    end

    def user_guess

        user_letter = gets.chomp.downcase

        if user_letter == "save"
            Dir.mkdir("save") unless Dir.exists?("save")

            File.open("save/save_file.dump",'w') { |f| f.write(YAML.dump(self)) }

            user_guess
        end

        if user_letter.length != 1 && user_letter != "save"
            user_guess
        else

            if @secret_word.include?(user_letter)
                replace_right_letters (user_letter)
            else
                add_wrong_letter (user_letter)
            end

            display_game_in_screen

        end
    end

    def display_secret_word

        if @displayable_secret_word[0].nil?
            i = 0
            while i != @secret_word.length
                @displayable_secret_word.push("_", " ")
                i += 1
            end
        end

        puts "\n\n#{@displayable_secret_word.join.upcase}"

    end

    def display_wrong_guesses

        puts "\nSpent letters: #{@wrong_letters.join(", ").upcase}\nWrong guesses to loose: #{@wrong_guesses_countdown}"

    end

    def check_end_of_the_game

        user_guessed_word = @displayable_secret_word - [" "]

        if @secret_word == user_guessed_word.join
            user_wins
        elsif @wrong_guesses_countdown == 0
            user_looses
        else
            user_guess
        end

    end

    def replace_right_letters(letter)

        secret_word_array = @secret_word.split("")
        i = 0

        while i < @secret_word.length
            if secret_word_array[i] == letter
                @displayable_secret_word[i * 2] = letter
            end

            i += 1
        end
    end

    def add_wrong_letter(letter)

        @wrong_guesses_countdown -= 1
        @wrong_letters.push(letter)

    end

    def user_wins

        puts "You win!"

        ask_to_play_again

    end

    def user_looses

        puts "You loose! The right word was:\n#{@secret_word.upcase}"

        ask_to_play_again

    end

    def ask_to_play_again

        puts "Do you want to play again? Write \"Y\" to confirm and \"N\" to stop playing"
        user_answer = gets.chomp.downcase

        if user_answer == "y"
            @secret_word = get_random_word
            @displayable_secret_word = []
            @wrong_guesses_countdown = 6
            @wrong_letters = []

            play_game
        elsif user_answer == "n"
            return
        else
            ask_to_play_again
        end

    end

    def draw_hangman

        a = "   _________\n  | /       |"
        b = "  |/"
        c = '  |'
        d = "  |"
        e = '  |'
        f = "  | \n__[_____________"

        case
        when @wrong_guesses_countdown == 6
            a = "   _________\n  | /       |"
            b = "  |/"
            c = '  |'
            d = "  |"
            e = '  |'
            f = "  | \n__[_____________"
        when @wrong_guesses_countdown == 5
            b = "  |/        O"
        when @wrong_guesses_countdown == 4
            b = "  |/        O"
            c = "  |         |"
            d = "  |         |"
        when @wrong_guesses_countdown == 3
            b = "  |/        O"
            c = "  |        /|"
            d = "  |         |"
        when @wrong_guesses_countdown == 2
            b = "  |/        O"
            c = '  |        /|\ '
            d = "  |         |"
        when @wrong_guesses_countdown == 1
            b = "  |/        O"
            c = '  |        /|\ '
            d = "  |         |"
            e = '  |        /  '
        when @wrong_guesses_countdown == 0
            b = "  |/        O"
            c = '  |        /|\ '
            d = "  |         |"
            e = '  |        / \ '
        end

        puts "#{a}\n#{b}\n#{c}\n#{d}\n#{e}\n#{f}"
    end

end

play = Game.new
play.start_the_game