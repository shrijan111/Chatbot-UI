stage('Install Dependencies') {
    steps {
        sh '''
        # Increase npm fetch retries in case of network hiccups
        npm set fetch-retries 5
        npm set fetch-retry-mintimeout 20000
        npm set fetch-retry-maxtimeout 120000

        # Optional: clean old node_modules and lock file for a fresh install
        rm -rf node_modules package-lock.json

        # Install dependencies with legacy peer deps
        npm install --legacy-peer-deps
        '''
    }
}
