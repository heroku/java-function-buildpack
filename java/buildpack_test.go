/*
 * Copyright 2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package java_test

import (
	"testing"

	"github.com/buildpack/libbuildpack/buildplan"
	"github.com/heroku/java-function-buildpack/java"
	"github.com/heroku/libfnbuildpack/function"
	"github.com/heroku/libhkbuildpack/test"
	. "github.com/onsi/gomega"
	"github.com/sclevine/spec"
	"github.com/sclevine/spec/report"
)

func TestName(t *testing.T) {
	spec.Run(t, "Id", func(t *testing.T, _ spec.G, it spec.S) {

		g := NewGomegaWithT(t)

		it("has the right id", func() {
			b := java.NewBuildpack()

			g.Expect(b.Id()).To(Equal("java"))
		})
	}, spec.Report(report.Terminal{}))
}

func TestBuild(t *testing.T) {
	spec.Run(t, "Build", func(t *testing.T, _ spec.G, it spec.S) {
		g := NewGomegaWithT(t)

		var f *test.BuildFactory
		var b function.Buildpack

		it.Before(func() {
			f = test.NewBuildFactory(t)
			b = java.NewBuildpack()
		})

		it("won't build unless passed detection", func() {
			err := b.Build(f.Build)

			g.Expect(err).To(MatchError("buildpack passed detection but did not know how to actually build"))
		})

		it.Pend("will build if passed detection", func() {
			f.AddBuildPlan(java.Dependency, buildplan.Dependency{})
			f.AddDependency(java.Dependency, ".")

			err := b.Build(f.Build)

			g.Expect(err).To(BeNil())
		})
	}, spec.Report(report.Terminal{}))
}
