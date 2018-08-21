from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist

distortions = list()

K_range = range(1, 10)
for k in K_range:
    kmeans = KMeans(n_clusters=k)
    kmeans.fit(X)
    distortions.append(sum(np.min(cdist(
        X, kmeans.cluster_centers_, 'euclidean'), axis=1)) / X.shape[0]
    )
    
fig, ax = plt.subplots(figsize=(15, 6))
ax.plot(K_range, distortions, 'bx-')
ax.grid(alpha=.7)
sns.despine()
ax.set_title('Elbow Method\nK-Means Clustering -- Optimal Number of Clusters')
ax.axvline(3, linestyle=':', c='red')
ax.set_xlabel('Number of Clusters')
ax.set_ylabel('Distortion (Cost Function)')
