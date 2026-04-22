import sqlite3
import pandas as pd
import matplotlib.pyplot as plt


conn = sqlite3.connect('practice.db')

with open("final_analysis.sql",'r') as file:
   query = file.read()


df = pd.read_sql_query(query,conn)

print(df.head())
print(df.shape)
print(df.columns)

df_sorted = df.sort_values("performance_gap_percent")

plt.figure(figsize = (8,5))

color = [
   'green' if  x>0 else 'red'
    for x in  df_sorted["performance_gap_percent"] 
]

plt.barh(
   df_sorted['Product_Category'],
   df_sorted['performance_gap_percent'],
   color = color
)

plt.axvline(0)

plt.title("Category Performance vs Regional Average(%)")
plt.xlabel("Performance Gap(%)")
plt.ylabel("Product Category")

plt.savefig("output_v2.png")
plt.tight_layout()
plt.show()



# New graph : Category + Region 

df["label"] = df['Product_Category'] + '(' + df['Region'] + ')'

df_sorted = df.sort_values("performance_gap_percent")


color = [
  'green' if x > 0 else 'red'
   for x in df_sorted['performance_gap_percent']
]


plt.figure(figsize=(10,7))

plt.barh(
  df_sorted['label'],
  df_sorted['performance_gap_percent'],

  color = color
)

plt.title("Category Performance by Region(%)")
plt.xlabel("Performance Gap(%)")
plt.ylabel("Category(Region)")

plt.savefig("category_region_performance.png",dpi=300)
plt.tight_layout()
plt.show()


