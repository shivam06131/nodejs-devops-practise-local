docker build -t my-express-app .
docker run -p 3000:3000 my-express-app

DOCKER_USERNAME = shivam6131
DOCKER_PASSWORD = GetMeIn@6131

Pass variables from github 
  Use it inside the workflow.yml
    working-directory: ${{ github.workspace }}

  Use inside docker-compose file 
      environment:
    - NODE_ENV=development
    - PORT=${{ secrets.PORT }}
    - TESTENV=${{ secrets.TESTENV }}