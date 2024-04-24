FROM public.ecr.aws/lambda/ruby:3.3.2024.04.17.17 AS build

RUN dnf install gcc make -y

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./

RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

FROM public.ecr.aws/lambda/ruby:3.3.2024.04.17.17 AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY . .

CMD [ "lib/snippet_extractor.SnippetExtractor.process" ]
