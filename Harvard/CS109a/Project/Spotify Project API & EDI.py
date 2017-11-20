from spotipy import util
import spotipy

## testing unique values found on home page of Spotify account
username = 'username' 
client_id = 'client_id'
client_secret = 'client_secret'
scope = 'user-library-read'
redirect_uri = 'http://localhost:8888/callback'

user_token = util.prompt_for_user_token(username, scope, 
                                       client_id=client_id,
                                       client_secret=client_secret, 
                                       redirect_uri=redirect_uri)
print(user_token)

urn = 'spotify:artist:3jOstUTkEu2JkjvRdBA5Gu'

## testing client credentials
from spotipy.oauth2 import SpotifyClientCredentials

client_credentials_manager = SpotifyClientCredentials(client_id, client_secret)
sp = spotipy.Spotify(auth=user_token, client_credentials_manager=client_credentials_manager)
sp.user('username')
sp.trace = True # turn on tracing
sp.trace_out = True # turn on trace out

artist = sp.artist(urn)
print(artist)

user = sp.user('agbvoe4uxyzq2tdzunsto3imn')
print(user)

## rabit holes to help understanding
?spotipy.Spotify
?SpotifyClientCredentials
