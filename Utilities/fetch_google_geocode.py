import pandas as pd
import requests

addresses = final_df['Primary Address'].astype(str) + ' ' + final_df['Primary City Name'] + ' ' + final_df['Primary State Abbreviation'] + ' ' + final_df['Primary Zip Code'].str.replace(',', '') + ' USA'
row_ids = final_df.index.values
address_dict = dict(zip(row_ids, addresses.tolist()))

def fetch_google_geocode(address, api_key=None, return_full_response=False):
    
    # set URL
    geocode_url = "https://maps.googleapis.com/maps/api/geocode/json?address={}".format(address)
    if api_key is not None:
        geocode_url = geocode_url + "&key={}".format(api_key)
        
    # Ping google for the reuslts, convert to JSON
    results = requests.get(geocode_url)
    results = results.json()
    
    # if there's no results or an error, return empty results.
    if len(results['results']) == 0:
        output = {
            "formatted_address" : None,
            "latitude": None,
            "longitude": None,
            "accuracy": None,
            "google_place_id": None,
            "type": None,
            "postcode": None
        }
    else:    
        answer = results['results'][0]
        output = {
            "formatted_address" : answer.get('formatted_address'),
            "latitude": answer.get('geometry').get('location').get('lat'),
            "longitude": answer.get('geometry').get('location').get('lng'),
            "accuracy": answer.get('geometry').get('location_type'),
            "google_place_id": answer.get("place_id"),
            "type": ",".join(answer.get('types')),
            "postcode": ",".join([x['long_name'] for x in answer.get('address_components') 
                                  if 'postal_code' in x.get('types')])
        }
        
    # Append some other details:    
    output['input_string'] = address
    output['number_of_results'] = len(results['results'])
    output['status'] = results.get('status')
    
    if return_full_response is True:
        output['response'] = results
    
    return output

api_key = 'API KEY NUMBER SEVEN'

fetch_google_geocode('4150 E La Paloma Dr Tucson AZ 85718 USA', api_key)
