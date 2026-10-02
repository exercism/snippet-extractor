ARG tag=3.3.2026.09.27.12-x86_64
FROM public.ecr.aws/lambda/ruby:${tag} AS build

RUN dnf install gcc make -y

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./

RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

FROM public.ecr.aws/lambda/ruby:${tag} AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY . .

CMD [ "lib/snippet_extractor.SnippetExtractor.process" ]
