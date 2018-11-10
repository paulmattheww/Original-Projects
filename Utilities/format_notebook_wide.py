## Markdown CSS
from IPython.core.display import HTML
HTML("""
<style>

div.cell { 
    margin-top:1em;
    margin-bottom:1em;
}

div.text_cell_render h1 {
    font-size: 1.6em;
    line-height:1.2em;
    text-align:center;
}

div.text_cell_render h2 {
margin-bottom: -0.2em;
}

table tbody tr td:first-child, 
table tbody tr th:first-child, 
table thead tr th:first-child, 
table tbody tr td:nth-child(4), 
table thead tr th:nth-child(4) {
    background-color: #edf4e8;
}

div.text_cell_render { 
    font-family: 'Garamond';
    font-size:1.3em;
    line-height:1.3em;
    padding-left:3em;
    padding-right:3em;
}

div#notebook-container    { width: 95%; }
div#menubar-container     { width: 65%; }
div#maintoolbar-container { width: 99%; }

</style>
""")
