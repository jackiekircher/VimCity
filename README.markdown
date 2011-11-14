    ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~
    {                                                                                                   }
    }                                                                                                   {
    {                         v     v  i  m mm mmm       ccc  i    t     y   y                          }
    }                          v   v   i  mm  m  m      c     i  ttttt    yyy                           {
    {                           v v    i  m   m  m      c     i    t       y                            }
    }                            v     i  m   m  m       ccc  i    ttt  yyy                             {
    {                                                                                                   }
    }                                                                                         \  |  /   {
    {            &                                                                             \_|_/    }
    }  ______    |                                                                       mooo! (o O)    {        
    {  |b  d|    |_____________                                                          ______[. .]    }
    }  |    |____| o  o  o  o |                                                         /         \     {        
    {  |b  d|T  T|   o  o  o  |____________                                            /|         |     }
    }  | __ |    |      _     |0 o     o 0|                                           * | |-----| |     {        
    {  | || |Y   |     | |    |     D     |                                             | |     | |     }
    ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~

_VimCity is a game that was designed and prototyped in 24 hours for the OSGCC 5 by the Sea Cucumbers team_
_consisting of Jackie Kircher, Andrea Della Corte, and Joanna Drummond. To read more about the_
_OSGCC visit [http://osgcc.org](http://osgcc.org). All development after the
[OSGCC-final tag](https://github.com/jackiekircher/VimCity/tree/OSGCC-final) has been done post-competition._

Welcome to VimCity! Extra-terrestrial development is the new frontier and real estate on Mars is
being bought up fast! Fortunately you've managed to secure a large plot of land and a few brave
settlers, and now it's time to put yourself in the history books. You'll need to balance your income,
population, and oxygen supply as you expand your city across the red planet. If you can't supply
enough oxygen for your citizens then they'll die, but oxygen isn't free so be careful not to expand
too quickly.


## Installation

1. Because working in VimScript is a nightmare, the bulk of VimCity is written
in ruby. As such, your version of Vim needs to be compiled with ruby support.
You can check if this is the case by running

        vim --version

    if you see the +ruby option then you're good to go.

2. VimCity also uses some support from the
[genutils plugin](http://www.vim.org/scripts/script.php?script_id=197),
so you'll need to install that.

3. Finally, I don't have plans on bundling the script up as proper vim plugin
until 1.0, so for now you'll just have to clone this project:

        git clone git://github.com/jackiekircher/VimCity.git

## Running

1. Once again, since the code isn't bundled properly to install with the rest
of your Vim plugins, you'll have to source it the old fashioned way. You can
do this by running

        :source vimcity.vim

    once you've opened up Vim, or you can load it from the command line with

        vim "+:source vimcity.vim"

2. After everything is loaded, just run

        :VimCity

    It will open the game in a new Vim tab so you don't have to worry about
losing any progress on your current buffer. However, until there's a more
stable release, I recommend saving all of your work before playing.

3. Have fun! Once you're in game hit '?' for help.



